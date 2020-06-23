Rails.application.routes.draw do
  root 'pages#welcome'
  devise_for :users
  get 'users/:id', to: 'users#show', as: 'user'

  resources :books, only: [:new, :create, :show, :index]
  get 'books/:id/processing', to: 'books#processing', as: 'processing'

  resources :contacts, only: [:show]
  get 'invalid_contacts', to: 'contacts#invalid_contact'
  get 'valid_contacts', to: 'contacts#valid_contact' 
  get 'all_contacts', to: 'contacts#all_contact'
end
