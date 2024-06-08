Rails.application.routes.draw do
  root 'pages#login'
  get 'home', to: 'pages#home', as: 'home'
  get 'login', to: 'pages#login'
  get 'recuperar_senha', to: 'pages#recuperar_senha'
end
