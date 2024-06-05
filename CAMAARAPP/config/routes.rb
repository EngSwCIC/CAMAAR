Rails.application.routes.draw do
  get '/gerenciamento', to: 'telas#gerenciamento'
  
  get '/tela_alunos', to: 'telas#tela_alunos'
  post 'telas/importar'
  post 'telas/mail'
  resources :alunos
end
