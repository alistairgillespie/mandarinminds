Rails.application.routes.draw do

  match '/edit_card',   to: 'users#edit_card',   via: 'get'
  match '/update_card', to: 'users#update_card', via: 'post'

  get 'errors/file_not_found'

  get 'errors/unprocessable'

  get 'errors/internal_server_error'

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

  # processing Stripe webhooks
  resources :stripe_events, only: [:create]

  get 'dashboard', :controller => 'users', :action => 'dashboard'

  get 'posts/page/:pagenumber', :controller => 'posts', :action => 'index'
  get 'posts/archive/:year/:month', :controller => 'posts', :action => 'view_archive'
  get 'posts/archive/:year', :controller => 'posts', :action => 'view_archive'
  
  
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/sign_out' => 'devise/sessions#destroy'
    get '/sign_in' => "devise/sessions#new"
  end
  devise_for :users, :path_names => {:sign_up => "register"}, :controllers => {:registrations => "registrations"}
  
  resources :posts
  
  resources :lessons

  post 'pusher/auth'

  get 'plans/:id' => 'charges#new', :as => 'charge_plan'
  post'/buy/:id', to: 'charges#create', as: :buy
  get 'charges' => 'charges#index', :as => 'charges'
  #get 'users' => 'users#show'
  resources :plans 
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
  get 'user_settings/toggle_config_morning_email' => 'user_settings#toggle_config_morning_email'
  resources :notifications

  get 'users/demote_to_student' => 'users#demote_to_student', as: 'demote_to_student'
  match 'users/promote_to_teacher' => 'users#promote_to_teacher', via: :get
  match '/teachers/update' => 'teachers#update', via: :post

  match 'users/:id' => 'users#show', as: :user, via: :get
  match 'lessons/request' => 'lessons#requestlesson', as: "request_lesson", via: :post
  match 'lessons/createlessonslot' => 'lessons#createlessonslot', as: "create_lesson_slot", via: :post
  match '/lessons/add_multiple' => 'lessons#add_multiple_lessons', via: :post
  get 'lessons/:id/booklessonslot' => 'lessons#booklessonslot', :as => "book_lesson_slot"
  get 'lessons/:id/confirm' => 'lessons#confirmlessonrequest', :as => "confirm_lesson"
  get 'notifications/dismiss_all' => 'notifications#dismiss_all', :as => "dismiss_all_notifications"
  get 'notifications/dismiss/:id' => 'notifications#dismiss', :as => "dismiss_notification"

  # Add static pages here. 
  # get "/extension" => "static#extension_in_controller"
  get "/asian-century" => "static#asian-century"
  get "/what-we-offer" => "static#what-we-offer"
  get "/pricing" => "static#pricing"
  get "/chatroom" => "static#chatroom"
  get "/teachers" => "static#teachers", as: 'teachers'
  get "/privacy" => "static#privacy"
  get "/terms" => "static#terms"
  get "/contact" => "static#contact"
  get "/faq" => "static#faq"
  
  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

end
