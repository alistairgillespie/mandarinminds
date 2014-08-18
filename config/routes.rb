Rails.application.routes.draw do
  #get 'test' => 'application#welcome'
  #get 'test2' => 'application#lessonalert'
  
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  devise_for :users, :path_names => {:sign_up => "register"}, :controllers => {:registrations => "registrations"}
  
  resources :posts
  resources :plans
  resources :lessons

  post 'pusher/auth'

  get 'charges/:id' => 'charges#new', :as => 'charge_plan'
  #get 'users' => 'users#show'
  
  
     
  #Redirected to rails default root if signed in 
  #unauthenticated do
  	get 'welcome/index'
    root to: "static#index"
  #end

  resources :posts do
    get "delete"
  end

  get 'notifications/get_notifications_for_header' => 'notifications#get_notifications_for_header'
  get 'notifications/get_notifications_for_bubble' => 'notifications#get_notifications_for_bubble'
  get 'notifications/:id/dismiss_and_view' => 'notifications#dismiss_and_view'
  get 'get_users_next_lesson' => 'lessons#get_users_next_lesson'
  resources :notifications

  

  match 'users/:id' => 'users#show', as: :user, via: :get
  match 'lessons/request' => 'lessons#requestlesson', as: "request_lesson", via: :post
  match 'lessons/createlessonslot' => 'lessons#createlessonslot', as: "create_lesson_slot", via: :post
  get 'lessons/:id/booklessonslot' => 'lessons#booklessonslot', :as => "book_lesson_slot"
  get 'lessons/:id/confirm' => 'lessons#confirmlessonrequest', :as => "confirm_lesson"
  get 'notifications/dismiss_all' => 'notifications#dismiss_all', :as => "dismiss_all_notifications"
  get 'notifications/dismiss/:id' => 'notifications#dismiss', :as => "dismiss_notification"

resources :notifications
  # Add static pages here. 
  # get "/extension" => "static#extension_in_controller"
  get "/asian-century" => "static#asian-century"
  get "/about" => "static#about"
  get "/pricing" => "static#pricing"
  get "/chatroom" => "static#chatroom"
  get "/teachers" => "static#teachers"
<<<<<<< HEAD
=======
  
  #if Rails.env.development?
  #  mount MailPreview => 'mail_view'
  #end
  
  
  
>>>>>>> integration
end
