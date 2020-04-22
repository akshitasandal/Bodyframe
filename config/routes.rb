Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: ''
  # resources :faqs
  namespace :web , path: '' do
    get '/faq' => 'faqs#index', as: :faq
    get '/csv' => 'users#index', as: :csv
    get '/payment_csv' => 'payment_histories#index', as: :payment_csv
    get '/approve/:id' => 'admin_payouts#approve', as: :approve
    get '/decline/:id' => 'admin_payouts#decline', as: :decline
    # resources :users
  end

  scope '', defaults: { format: :json } do
    resources :apidocs, only: :index
    get '/assign_clients', to: 'users#assign_clients'

    devise_scope :user do
      post 'login', to: 'devise_token_auth/sessions#create'
      post 'sign_up', to: 'devise/registrations#create'
      delete 'sign_out', to: 'devise_token_auth/session#destroy'
      post 'forgot_password', to: 'devise/passwords#create'
      patch 'update_forgot_password', to: 'devise/passwords#update'
    end
    get '/user', to: 'users#show', as: :user
    get '/mark_as_read/:id', to: 'users#mark_as_read'
    patch '/update_profile', to: 'users#update_profile'
    patch 'update_password', to: 'users#update_password'
    patch 'cancel_my_account', to: 'users#cancel_my_account'
    post '/subscribe_user', to: 'credit_cards#subscribe_user'
    post '/subscribe_client', to: 'credit_cards#subscribe_client'
    get '/trainer_wallet', to: 'credit_cards#trainer_wallet'
    get '/billing_history', to: 'credit_cards#billing_history'
    get '/payment_information', to: 'credit_cards#payment_information'
    patch '/wallet_withdrawal', to: 'credit_cards#wallet_withdrawal'
    get '/client_payment_history', to: 'credit_cards#client_payment_history'
    post '/match_coupon_code', to: 'credit_cards#match_coupon_code'
    resources :admin_payouts
    resources :device_tokens do
      collection do
        delete '/delete_token', to: 'device_tokens#delete_token'
      end
    end
    resources :bank_accounts
    resources :credit_cards, only: [:create, :destroy, :update]
    resources :workout_categories
    resources :meal_categories
    namespace :trainer do
      resources :workouts
      resources :meals
      resources :clients
      resources :invitations, only: :create
      resources :notifications
      resources :upgrade_requests
    end
    post '/upload_video', to: 'users#upload_video'
    get '/client', to: 'client#show'
    post '/match_referral_code', to: 'client#match_referral_code'
    patch '/client/:id', to: 'client#update'
    namespace :client do
      resources :workouts
      resources :meals
      resources :notifications
    end
  end
  # custom routes 
  get '/admin/admin_payouts'
  
  # custom routed
  get '*other', to: 'application#static'
end
