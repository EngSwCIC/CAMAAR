# evita o erro 406
Rails.application.routes.default_url_options[:host] = 'http://localhost:3000'

Rails.application.routes.draw do
  root 'home#index'
  resources :respostas
  resources :questoes
  resources :materias
  get 'gerenciamento', to: 'home#gerenciamento', as: 'gerenciamento'
  get 'resultados', to: 'home#resultados', as: 'resultados'
  post 'enviar_formularios', to: 'home#enviar_formularios', as: 'enviar_formularios'
  resources :materia
  resources :questaos
  resources :formularios
  resources :turmas
  resources :imports, only: [:create]
  devise_for :users, controllers: { passwords: 'users/passwords', confirmations: 'users/confirmations'}
  resources :templates
end