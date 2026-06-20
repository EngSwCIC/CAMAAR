Rails.application.routes.draw do
  root "login#index"
  get "login", to: "login#index", as: nil
  post "login", to: "login#create", as: nil
  delete "logout", to: "login#destroy", as: nil

  get "signup", to: "usuarios#new"
  post "signup", to: "usuarios#create"

  get "gerenciamento", to: "pages#gerenciamento"
  get "avaliacoes", to: "pages#avaliacoes"

  post   "gerenciamento/importar",    to: "gerenciamento#importar",    as: :importar_dados
  delete "gerenciamento/limpar",     to: "gerenciamento#limpar",      as: :limpar_dados
  get  "gerenciamento/templates",   to: "gerenciamento#templates",   as: :editar_templates
  get  "gerenciamento/formularios", to: "gerenciamento#formularios", as: :enviar_formularios
  post "gerenciamento/formularios", to: "gerenciamento#criar_formulario"
  get  "gerenciamento/resultados",  to: "gerenciamento#resultados",  as: :resultados

  resources :template_formularios, only: [:show, :new, :create, :edit, :update, :destroy]

  # Logged-in password change
  get  "senha/redefinir", to: "senha#redefinir", as: :senha_redefinir
  post "senha/redefinir", to: "senha#atualizar"

  # Forgot-password flow (no login required)
  get  "senha/recuperar", to: "senha#recuperar", as: :recuperar_senha
  post "senha/recuperar", to: "senha#solicitar"
  get  "senha/nova",      to: "senha#nova",      as: :senha_nova
  post "senha/nova",      to: "senha#salvar"

  get "login", to: "login#index", as: nil
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get  "login",  to: "sessions#new",     as: :login
  post "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :formularios, only: [:index, :show] do
    resources :respostas, only: [:create]
  end

  resources :relatorios, only: [:index, :show] do
    get :export_csv, on: :member
  end

  get  "departamento",            to: "departamentos#index", as: :departamento
  get  "departamento/turmas/:id", to: "departamentos#show",  as: :departamento_turma

  post   "turma_formularios",     to: "turma_formularios#create",  as: :turma_formularios
  delete "turma_formularios/:id", to: "turma_formularios#destroy", as: :turma_formulario
end
