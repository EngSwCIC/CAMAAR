Rails.application.routes.draw do
  devise_for :users
  get '/gerenciamento', to: 'telas#gerenciamento'
  
  get '/tela_alunos', to: 'telas#tela_alunos'
  post 'telas/importar'
end
