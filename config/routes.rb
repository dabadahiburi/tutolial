Rails.application.routes.draw do
  get 'password_reset/new'
  get 'password_reset/edit'
  get 'sessions/new'
  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/contact'
  get 'users/new'#singup
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only:[:edit]
  resources :password_reset,      only:[:new,:create,:edit,:update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
