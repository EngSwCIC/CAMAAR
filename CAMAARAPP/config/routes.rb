Rails.application.routes.draw do
  get "/users/sign_up/:id", to: "telas#cadastro", as:"id"

  devise_for :users 

  get '/gerenciamento', to: 'telas#gerenciamento'


  get '/tela_alunos', to: 'telas#tela_alunos'
  post 'telas/importar'
  post 'telas/mail'
  resource :id
  resources :alunos
end
