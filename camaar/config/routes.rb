Rails.application.routes.draw do
  root 'pages#login'
  get 'home', to: 'pages#home', as: 'home'
  get 'login', to: 'pages#login', as: 'login'
  get 'recuperar_senha', to: 'pages#recuperar_senha', as: 'recuperar_senha'
  get 'criar_templete', to: 'pages#criar_templete', as: 'criar_templete'
  post 'login', to: 'sessions#create'

  resources :questions, only: [:create]
  resources :surveys, only: [:create]

end
