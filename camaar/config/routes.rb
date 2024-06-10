Rails.application.routes.draw do
  root 'pages#login'
  get 'home', to: 'pages#home', as: 'home'
  get 'login', to: 'pages#login', as: 'login'
  get 'recuperar_senha', to: 'pages#recuperar_senha', as: 'recuperar_senha'
  post 'login', to: 'sessions#create'
end
