Rails.application.routes.draw do
  root "sessions#new"

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :passwords, only: [:edit, :update]

  resources :avaliacoes, only: [:index]
  resources :formularios, only: [:show] do
    post 'responder', on: :member
  end

  namespace :admin do
    root "gerenciamento#index"
    
    resources :imports, only: [:new, :create]
    resources :templates
    resources :formularios, only: [:new, :create]
    
    resources :resultados, only: [:index, :show] do
      get 'exportar_csv', on: :member
    end
  end
end