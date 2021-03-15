Rails.application.routes.draw do

  get 'posts/new'
  get 'posts/index'
  get 'posts/show'
  get 'posts/edit'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
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
    resources :photos, only: [:create]
    resources :likes, only: [:index, :create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
end
