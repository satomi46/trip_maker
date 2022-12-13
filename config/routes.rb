Rails.application.routes.draw do
  devise_for :users
  root to: "trips#index"
  resources :trips do
    resources :details, only: [:create, :edit, :update, :destroy]
  end
  resources :users, only: :show
end
