Timemsgr::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" }  
  
  # controllers for event related content
  resources :members, :promotions, :presenters, :event_sessions
  
  resources :channels, :observance_events
   
  resources :major_events do
    member do 
      get 'register', 'about'
    end
    get 'list', :on => :collection
  end
  
  # controllers for user specific content
  resources :interests, :subscriptions, :authentications, :associates
  
  resources :events do 
    member do
      get 'share', 'like', 'notify', 'offer', 'rsvp', 'purchase'
    end
  end
   
  resources :private_events do
    member do
      get 'add', 'clone', 'move', 'share', 'like', 'notify', 'offer', 'rsvp', 'purchase'
    end
    
    collection do
      get 'manage', 'import', 'clock', 'getquote'
    end
  end
    
  resources :affiliations do
    get :autocomplete_organization_name, :on => :collection
  end  
  
  resources :users, :except => [:show] 
  
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
  match '/metrics', :to => 'users#show' 
    
  # route custom event actions
  match '/outlook', :to => 'events#outlook', :as => "outlook"
  match '/gcal_import', :to => 'events#gcal_import', :as => "gcal_import"
  
  # add route for dynamically changing event types
  #match "/get_drop_down_options", :to => "events#get_drop_down_options"

  root :to => 'pages#home'
end
