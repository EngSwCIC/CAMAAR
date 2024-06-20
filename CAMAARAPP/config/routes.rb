Rails.application.routes.draw do
<<<<<<< Updated upstream
  devise_for :users
=======
  devise_for :admins
  get "/users/sign_up/:id_aluno", to: "telas#cadastro", as:"id_aluno"

  devise_for :users 
  root'telas#gerenciamento'
>>>>>>> Stashed changes
  get '/gerenciamento', to: 'telas#gerenciamento'
  
  get '/tela_alunos', to: 'telas#tela_alunos'
  get '/user/tela_alunos', to: 'telas#tela_alunos'
  post 'telas/importar'
<<<<<<< Updated upstream
=======
  post 'telas/mail'
  resource :id
  resources :alunos
  resource :senha
  resources :users

  get "/confirmar_senha", to: 'telas#cadastro_aluno'


>>>>>>> Stashed changes
end
