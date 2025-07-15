Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Login
  get 'login', to: 'login#new'
  post 'login', to: 'login#create'
  delete 'logout', to: 'login#destroy'

  # Password reset routes
  get 'password/reset', to: 'passwords#new', as: :new_password
  post 'password/reset', to: 'passwords#create', as: :password_reset
  get 'password/reset/:id', to: 'passwords#edit', as: :edit_password
  patch 'password/reset/:id', to: 'passwords#update', as: :password_reset_update

  # Área do admin
  namespace :admin do
    get 'gerenciamento', to: 'gerenciamento#index', as: :gerenciamento
  end

  # Área do usuário comum (docente, discente)
  namespace :user do
    get 'avaliacoes', to: 'avaliacoes#index' # user/avaliacoes
  end

  # Página inicial (login)
  root to: 'login#new'
end
