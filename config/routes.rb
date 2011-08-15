Timemsgr::Application.routes.draw do

  devise_for :users  
  
  resources :members, :interests, :subscriptions, :authentications, :associates
   
  resources :events do
    member do
      get 'clone', 'move', 'share', 'like', 'notify', 'offer', 'rsvp', 'purchase'
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
  	root :to => "users#home"
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
  match '/welcome', :to => 'users#new'
  match '/home', 	:to => 'events#index'
  match '/home/user', :to => 'users#home' 
  match '/metrics', :to => 'users#show' 
    
  # route custom event actions
  match '/outlook', :to => 'events#outlook', :as => "outlook"
  match '/gcal_import', :to => 'events#gcal_import', :as => "gcal_import"
  
  # add route for dynamically changing event types
  match "/get_drop_down_options", :to => "events#get_drop_down_options"
  match "*path" => 'error#handle404' # catch any routing errors

  root :to => 'pages#home'
end
