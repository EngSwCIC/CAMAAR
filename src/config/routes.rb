Rails.application.routes.draw do
  resources :respostas
  resources :questoes
  resources :materias
  
  resources :materia
  resources :questaos
  resources :formularios
  resources :resposta
  resources :turmas
  devise_for :users
  
  root 'home#index'
  
  resources :templates

  resources :imports, only: [:new, :create]
end

