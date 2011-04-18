Timemsgr::Application.routes.draw do

 
#  get "users/index"
#  get "users/show"
#  get "subscriptions/new"

#  get "sessions/new"
#  get "member/new"

  devise_for :users
  
  resources :members
  resources :users 
  resources :events, :interests, :associates, :subscriptions
  
  # match "affiliations/list" => "affiliations#list"

  resources :affiliations do
  	get :autocomplete_affiliation_name, :on => :collection
  end
  

  # specify routes for devise user after sign-in
  namespace :user do
  	root :to => "users#home"
  end

  # change default user route
#  match 'member' => 'member#new', :as => 'user_path'  
#  match 'member' => 'member#index', :as => 'user_root'  
#  match '/logout', :to => 'member#destroy'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
 # match '/signup', :to => 'member#new'
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/company', :to => 'pages#company'
  match '/privacy', :to => 'pages#privacy'
  
  # set up user routes
#  match '/friends', :to => 'users#friends'
  match '/welcome', :to => 'users#new'
  match '/home', 	:to => 'events#index'
  
  # set up subscription routes
#  match '/channels', :to => 'subscriptions#channels'
# match '/subscriptions/new', :to => 'subscriptions#new'

  # catch any routing errors
  match "*path" => 'error#handle404'

  root :to => 'pages#home'


  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
