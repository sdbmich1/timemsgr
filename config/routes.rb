Timemsgr::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" }  
    
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
  resources :categories, :interests,  :authentications, :associates, :host_profiles, :rsvps, :searches, :search_channels, 
    :search_users
  
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
  resources :members, :promotions, :presenters, :event_sessions, :transactions, :subscriptions, :notifications, :event_notices
  
  resources :relationships do
    collection do
      get 'private', 'social', 'pending', 'extended'
    end 
  end
   
  resources :affiliations do
    get :autocomplete_organization_OrgName, :on => :collection
  end  
  
  resources :users 
  
  # specify routes for devise user after sign-in
  namespace :user do
  	root :to => "users#home", :as => :user_root
  end

  # add authentication route callback
  match "/auth/failure", :to => "authentications#failure"
  match '/auth/:provider', :to => 'authentications#blank'
  match '/auth/:provider/callback', :to => 'authentications#create' 

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
  match '/events/notice', :to =>  "events#notice"
  match '/select', :to =>  "channels#select"
    
  # route custom event actions
  match '/outlook', :to => 'events#outlook', :as => "outlook"
  match '/gcal_import', :to => 'events#gcal_import', :as => "gcal_import"
  match '/system/photos/:id/:style/:basename.:extension', :to => 'pictures#asset'

  # add route for dynamically changing event types
  #match "/get_drop_down_options", :to => "events#get_drop_down_options"

  root :to => 'pages#home'
#  root :to => 'events#index'
end
