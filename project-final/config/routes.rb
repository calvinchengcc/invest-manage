Rails.application.routes.draw do
  resources :stocks
  resources :portfolios
  resources :addresses
  resources :portfolios
  resources :holdings
  root to: 'visitors#index'
  devise_for :users
end
