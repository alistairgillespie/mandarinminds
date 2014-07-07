Rails.application.routes.draw do
  resources :lessons
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  devise_for :users, :path_names => {:sign_up => "register"} 
    #devise_scope :user do
	#get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  #end
  
  get 'welcome/index'
  # You can have the root of your site routed with "root"
  root 'static#index'
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  match 'users/:id' => 'users#show', as: :user, via: :get

  get 'lessons/:id/confirm' => 'lessons#confirm', :as => "confirm_lesson"

  # Add static pages here. 
  # get "/extension" => "static#extension_in_controller"
  get "/asian-century" => "static#asian-century"
  get "/pricing" => "static#about"
  get "/about" => "static#pricing"
  get "/chatroom" => "static#chatroom"
  
  
end
