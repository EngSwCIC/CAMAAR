Rails.application.routes.draw do
  root 'home#index'
  resources :respostas
  resources :questoes
  resources :materias
  
  resources :materia
  resources :questaos
  resources :formularios
  resources :resposta
  resources :turmas
  resources :imports, only: [:create]
  devise_for :users, controllers: { passwords: 'users/passwords', confirmations: 'users/confirmations'}
  resources :templates
end