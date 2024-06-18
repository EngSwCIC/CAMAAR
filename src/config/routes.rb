Rails.application.routes.draw do
  root 'home#index'
  resources :respostas
  resources :questoes
  resources :materias  
  resources :formularios
  resources :turmas
  resources :imports, only: [:create]
  devise_for :users  
  resources :templates
end