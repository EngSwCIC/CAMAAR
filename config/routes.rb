# config/routes.rb
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "sessions#new"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  get "/admin", to: "dashboards#admin", as: :admin_dashboard
  get "/discente", to: "dashboards#discente", as: :discente_dashboard
  resources :turmas, only: [ :index, :show ]

  get "/avaliacao", to: "dashboards#admin_avaliacao", as: :admin_avaliacao_dashboard
  get "/gerenciamento", to: "dashboards#admin_gerenciamento", as: :admin_gerenciamento_dashboard

  get "/definir_senha", to: "passwords#edit", as: :definir_senha
  patch "/definir_senha", to: "passwords#update", as: :definir_senha_update

  # usando o controller existente
  # get '/json/importar', to: 'json#importar'
  # get '/json/resultados', to: 'json#resultados'
  post "admin/importar_json", to: "dashboards#importar_json", as: :importar_json

  resources :formularios, only: [ :index, :show ] do
    member do
      get :minha_resposta
    end
  end

  resources :envio_formularios, only: [ :new, :create ]

  resources :turmas, only: [ :index, :show ]

  resources :templates, only: [ :index ]
end
