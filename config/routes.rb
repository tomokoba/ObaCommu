Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  root 'homes#top'

  resources :users, except: [:new, :create, :destroy] do
    member do
     get :following, :followers
    end
  end

  get 'users/:id/unsubscribe' => 'users#unsubscribe', as: 'confirm_unsubscribe'
  patch 'users/:id/withdraw' => 'users#withdraw', as: 'withdraw_user'
  put 'users/:id/withdraw' => 'users#withdraw'

  resources :posts do
    collection do
      get :rank
    end
    resources :photos, only: [:create]
    resources :likes, only: [:index, :create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]

  resources :contacts, only: [:new, :create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  post 'contacts/back', to: 'contacts#back', as: 'back'
end
