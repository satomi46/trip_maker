Rails.application.routes.draw do
  devise_for :users
  root to: "trips#index"
  resources :trips do
    resources :details, only: [:create, :edit, :update, :destroy]
    resources :fixed_trips, only: [:new, :create, :destroy]
  end
  resources :users, only: :show do
    resources :relationships, only: [:create, :destroy]
  end
end
