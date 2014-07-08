Rails.application.routes.draw do
  resources :lessons
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  devise_for :users, :path_names => {:sign_up => "register", } 
  
  authenticated :user do
    root to: "users#show", as: :authenticated_root
  end
  
  unauthenticated do
  	get 'welcome/index'
    root to: "static#index"
  end
    
  match 'users/:id' => 'users#show', as: :user, via: :get
  get 'lessons/:id/confirm' => 'lessons#confirm', :as => "confirm_lesson"

  # Add static pages here. 
  # get "/extension" => "static#extension_in_controller"
  get "/asian-century" => "static#asian-century"
  get "/about" => "static#about"
  get "/pricing" => "static#pricing"
  get "/chatroom" => "static#chatroom"
  
end