Rails.application.routes.draw do
  resources :notifications
  resources :plans

  resources :lessons
  
  get 'charges/:id' => 'charges#new', :as => 'charge_plan'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  devise_for :users, :path_names => {:sign_up => "register", } 
   
  #Redirected to rails default root if signed in 
  #unauthenticated do
  	get 'welcome/index'
    root to: "static#index"
  #end


    
  match 'users/:id' => 'users#show', as: :user, via: :get

  match 'lessons/request' => 'lessons#requestlesson', as: "request_lesson", via: :post
  match 'lessons/createlessonslot' => 'lessons#createlessonslot', as: "create_lesson_slot", via: :post
  get 'lessons/:id/booklessonslot' => 'lessons#booklessonslot', :as => "book_lesson_slot"
  get 'lessons/:id/confirm' => 'lessons#confirmlessonrequest', :as => "confirm_lesson"

  # Add static pages here. 
  # get "/extension" => "static#extension_in_controller"
  get "/asian-century" => "static#asian-century"
  get "/about" => "static#about"
  get "/pricing" => "static#pricing"
  get "/chatroom" => "static#chatroom"
  
end
