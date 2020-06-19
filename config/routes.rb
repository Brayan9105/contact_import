Rails.application.routes.draw do
  root 'pages#welcome'
  devise_for :users
  resources :books, only: [:new, :create, :show, :index]
end
