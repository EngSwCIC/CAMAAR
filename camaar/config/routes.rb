Rails.application.routes.draw do
  root 'pages#login'

  get 'home', to: 'pages#home', as: 'home'
  get 'login', to: 'pages#login', as: 'login'
  post 'login', to: 'sessions#create'

  post 'verify_user', to: 'sessions#verify_user', as: 'verify_user'


  get 'recuperar_senha', to: 'pages#recuperar_senha', as: 'recuperar_senha'

  get 'criar_templete', to: 'pages#criar_templete', as: 'criar_templete'

  # Rotas para sessões (login/logout)
  delete '/logout', to: 'sessions#destroy'
end
