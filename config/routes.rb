Rails.application.routes.draw do
  get 'chats/show'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  root 'homes#top'

  resources :users, except: [:new, :create] do
    member do
      get :following, :followers, :likes
    end
  end

  get 'users/:id/unsubscribe', to: 'users#unsubscribe', as: 'confirm_unsubscribe'

  resources :posts do
    collection do
      get :rank
    end
    resources :photos, only: [:create]
    resources :likes, only: [:index, :create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]

  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]
  resources :contacts, only: [:new, :create] do
    collection do
      get 'confirm', to: 'contacts#error'
      post 'confirm'
      get 'back', to: 'contacts#error'
      post 'back'
    end
  end
end
