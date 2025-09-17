Rails.application.routes.draw do
  devise_for :users

  root to: "posts#index"

  resources :follow_requests, only: [ :create, :update, :destroy ]
  resources :users, only: [ :index, :show ]

  resources :posts do
    resources :comments, only: [ :create, :destroy ]
    resources :likes, only: [ :create, :destroy ]
  end
end
