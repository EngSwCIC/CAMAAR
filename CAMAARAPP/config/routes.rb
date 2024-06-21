Rails.application.routes.draw do
  get "/users/sign_up/:id_aluno", to: "telas#cadastro", as:"id_aluno"

  devise_for :users 

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  get '/gerenciamento', to: 'telas#gerenciamento'
  post "cadastro/cadastro_aluno"
  post 'telas/cadastro_aluno'
  get '/tela_alunos', to: 'telas#tela_alunos'
  get '/user_home', to: 'telas#user_home'
  get '/user/tela_alunos', to: 'telas#user_home'

  post 'telas/importar'
  post 'telas/mail'
  resource :id
  resources :alunos
  resource :senha
  resources :users



  get "/confirmar_senha", to: 'telas#cadastro_aluno'
end
