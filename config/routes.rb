Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Login
  get 'login', to: 'login#index'
  post 'login', to: 'login#create'
  delete 'logout', to: 'login#destroy'

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