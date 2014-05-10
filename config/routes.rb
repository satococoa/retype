Rails.application.routes.draw do
  resources :sites do
    post :deploy, on: :member
    resources :pages do
      get :preview, on: :member
    end
  end

  devise_for :users
  root to: 'statics#index'
  resources :statics, only: :index

  get 'event' => 'demo#event'
end
