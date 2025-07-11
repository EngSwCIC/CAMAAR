Rails.application.routes.draw do
  get "home/index"
  # Configurações do Devise
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :cursos
  get "evaluations/index"
  resources :users do
    member do
      patch :toggle_active
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'home#index'

  # Rotas para a nova página de Avaliações
  get 'evaluations', to: 'evaluations#index'

  # Rota administrativa para cadastro de usuários (apenas admins)
  get 'admin/users/new', to: 'admin/users#new', as: :new_admin_user
  post 'admin/users', to: 'admin/users#create', as: :admin_users
end
