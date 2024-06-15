Rails.application.routes.draw do
  get "/users/sign_up/:id_aluno", to: "telas#cadastro", as:"id_aluno"

  devise_for :users 

  get '/gerenciamento', to: 'telas#gerenciamento'
  post "cadastro/cadastro_aluno"
  post 'telas/cadastro_aluno'
  get '/tela_alunos', to: 'telas#tela_alunos'
  post 'telas/importar'
  post 'telas/mail'
  resource :id
  resources :alunos
  resource :senha

  get "/confirmar_senha", to: 'telas#cadastro_aluno'
end
