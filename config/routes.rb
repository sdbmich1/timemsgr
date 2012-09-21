Timemsgr::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" , :omniauth_callbacks => "users/omniauth_callbacks", :sessions => 'sessions' } 
  
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    get '/users/auth/:provider/setup' => 'users/omniauth_callbacks#setup'
  end 
    
  resources :channels do
    get 'about', :on => :member
  end
  
  resources :life_events do
    get 'clone', :on => :member
  end
   
  resources :major_events do
    member do 
      get 'register', 'about'
    end
    get 'list', :on => :collection
  end
  
  # controllers for user specific content
  resources :interests, :categories, :authentications, :associates, :host_profiles, :rsvps, :searches, :search_channels, 
    :search_users, :search_private_events, :local_channels, :maps, :import_events, :search_nearby_events
    
  resources :local_subscriptions, :only => [:create, :new]
  resources :nearby_events, :only => [:index]

  resources :events do 
    member do
      get 'share', 'like', 'notify', 'offer', 'rsvp', 'purchase'
    end
    
    collection do
      get 'clock', 'getquote'
    end
  end
   
  resources :private_events do
    member do
      get 'add', 'move', 'clone', 'share', 'like', 'notify', 'offer', 'rsvp', 'purchase'
    end
    
    collection do
      get 'manage', 'import', 'clock', 'getquote'
    end
  end
 
  resources :scheduled_events do
    member do
      get 'clone', 'add', 'notify', 'share'
    end
  end 
    
  # controllers for event related content
  resources :presenters, :event_sessions, :subscriptions, :notifications, :event_notices, :beta_feedbacks
  
  resources :relationships do
    collection do
      get 'private', 'social', 'pending', 'extended'
    end 
  end
   
  resources :affiliations do
    get :autocomplete_organization_OrgName, :on => :collection
  end  
  
  resources :users, :except => [:new, :create] 
  
  # specify routes for devise user after sign-in
  namespace :user do
  	root :to => "users#home", :as => :user_root
  end

  # set up general routes
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/company', :to => 'pages#company'
  match '/privacy', :to => 'pages#privacy' 
  match '/browse', :to => 'pages#browse' 
  match '/welcome', :to => 'users#new'
  match '/home', 	:to => 'events#index'
  match '/home/user', :to => 'users#home' 
  match '/metrics', :to => 'users#metrics' 
  match '/notify', :to =>  "events#notify"
  match '/notice', :to =>  "events#notice"
  match '/directions', :to =>  "maps#directions"  
  match '/details', :to =>  "maps#details"  
  match '/select', :to =>  "channels#select"
  match '/list', :to =>  "categories#list"
  match "/suggestions", :to => "affiliations#suggestions"
  match "/auth/failure", :to => "sessions#failure"   
    
  # route custom event actions
  match '/outlook', :to => 'private_events#outlook', :as => "outlook"
  match '/gcal_import', :to => 'private_events#gcal_import', :as => "gcal_import"
  match '/system/photos/:id/:style/:basename.:extension', :to => 'pictures#asset'

  root :to => 'pages#home'
end
