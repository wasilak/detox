Detox::Application.routes.draw do

  # match '/tags' => 'tags#index', :via => :post
  # match '/expenses' => 'expenses#index', :via => :post

  resources :tags

  resources :users

  resources :expenses

  resources :budgets

  get "home/index"

  match 'home/login' => 'home#login', :as => :login
  match 'home/checkLogin' => 'home#checkLogin', :as => :checkLogin
  match 'home/logout' => 'home#logout', :as => :logout

  match 'expenses/:id/add_tag' => 'expenses#add_tag', :as => :add_tag
  match 'expenses/:id/del_tag' => 'expenses#del_tag', :as => :del_tag

  match 'expenses/set_budget' => 'expenses#set_budget', :as => :set_budget

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
