Rails.application.routes.draw do
  resources :sites

  devise_for :users
  root to: 'statics#index'
  resources :statics, only: :index

  get 'event' => 'demo#event'
end
