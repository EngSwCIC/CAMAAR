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
    get 'gerenciamento', to: 'gerenciamento#index'  # Rota: /admin/
  end

  # Área do Usuário
  get 'gerenciamento', to: 'users#gerenciamento', as: :user_dashboard  # /gerenciamento
  # get 'profile', to: 'users#profile'  # Exemplo de outra rota de usuário

  # Página inicial
  root 'login#index'

  # PWA (opcional)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end