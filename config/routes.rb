Rails.application.routes.draw do
  devise_for :users
  root to: "trips#index"
  resources :trips
  resources :users, only: :show
end
