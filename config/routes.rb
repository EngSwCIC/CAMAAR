Rails.application.routes.draw do
  root "sessions#new"

  get "/inicio", to: "home#index", as: :inicio
  post "/login", to: "sessions#create", as: :login
  delete "/logout", to: "sessions#destroy", as: :logout

  get "/definir_senha/:token", to: "definicao_senhas#edit", as: :edit_definicao_senha
  patch "/definir_senha/:token", to: "definicao_senhas#update", as: :definicao_senha

  get "/redefinir_senha", to: "redefinicao_senhas#new", as: :redefinir_senha
  post "/redefinir_senha", to: "redefinicao_senhas#create"
  get "/redefinir_senha/:token", to: "redefinicao_senhas#edit", as: :edit_redefinicao_senha
  patch "/redefinir_senha/:token", to: "redefinicao_senhas#update", as: :redefinicao_senha

  resources :resposta_elems
  resources :resposta_forms
  resources :campo_forms
  resources :elemento_forms
  resources :formularios
  resources :campos
  resources :elementos
  resources :docentes
  resources :discentes
  resources :usuarios
  resources :turmas
  resources :disciplinas
  resources :cursos
  resources :departamentos

  # User forms (responder avaliações)
  resources :forms, only: [ :index, :show ] do
    member do
      post :create_response
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "/up" => "rails/health#show", as: :rails_health_check

  # Admin routes
  namespace :admin do
    get "/", to: redirect("/admin/avaliacoes")

    get "avaliacoes", to: "dashboard#index"
    get "gerenciamento", to: "dashboard#gerenciamento"

    resources :forms, only: [ :index, :new, :create ] do
      member do
        post :publish
        get :results
      end
    end

    resources :templates

    get  "sincronizar_sigaa", to: "dashboard#sincronizar_sigaa", as: :sincronizar_sigaa
    post "sincronizar_sigaa", to: "dashboard#sincronizar_sigaa"
  end

  get "/admin/resultados", to: "admin#resultados", as: :admin_resultados
  get "/admin/resultados/:id/download.csv", to: "admin#exportar_csv", as: :baixar_csv
end
