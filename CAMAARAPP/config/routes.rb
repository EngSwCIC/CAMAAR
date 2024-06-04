Rails.application.routes.draw do
  get '/gerenciamento', to: 'telas#gerenciamento'
  
  post 'telas/importar'
end
