Rails.application.routes.draw do
  resources :stocks
  resources :portfolios
  resources :addresses
  resources :portfolios
  resources :holdings
  resources :users do
    collection do
      get 'stats' => 'users#stats'
    end
  end
  root to: 'visitors#index'
  devise_for :users, path: 'u'
end
