Rails.application.routes.draw do
  root 'pages#login'

  get 'home', to: 'pages#home', as: 'home'
  post 'home', to: 'pages#home'
  get 'login', to: 'pages#login', as: 'login'
  post 'login', to: 'sessions#create'

  #Rotas de passar dados em teste
  post 'teste_create', to: 'teste#teste_create'
  post 'teste_definir_senha', to: 'teste#definir_senha'

  # Rota para lidar com a importação de dados
  post '/importar_dados', to: 'pages#importar_dados'

  post 'verify_user', to: 'sessions#verify_user', as: 'verify_user'


  get 'recuperar_senha', to: 'pages#recuperar_senha', as: 'recuperar_senha'
  post 'update_password', to: 'pages#update_password', as: 'update_password'

  get 'criar_templete', to: 'pages#criar_templete', as: 'criar_templete'

  # Rotas para sessões (login/logout)
  delete '/logout', to: 'sessions#destroy'
end
