Rails.application.routes.draw do
  devise_for :users
  root to: 'statics#index'
  resources :statics, only: :index
end
