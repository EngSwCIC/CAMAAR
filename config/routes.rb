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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  scope "/admin/:admin_id", as: "admin" do
    get "avaliacoes", to: "admin#avaliacoes", as: :avaliacoes
    get "gerenciamento", to: "admin#gerenciamento", as: :gerenciamento
    resources :templates
    get  "sincronizar_sigaa", to: "admin#sincronizar_sigaa", as: :sincronizar_sigaa
    post "sincronizar_sigaa", to: "admin#sincronizar_sigaa"
    get  "enviar_formularios", to: "admin#enviar_formularios", as: :enviar_formularios
    post "enviar_formularios", to: "admin#enviar_formularios"
    get "resultados", to: "admin#resultados", as: :resultados
    get "resultados/:id/download.csv", to: "admin#exportar_csv", as: :baixar_csv
  end

  scope "/usuarios/:usuario_id", as: "usuarios" do
    get "avaliacoes", to: "usuarios#avaliacoes", as: :avaliacoes
    get "formularios/:formulario_id/responder", to: "usuarios#responder_formulario", as: :responder_formulario
    post "formularios/:formulario_id/responder", to: "usuarios#submeter_resposta", as: :submeter_resposta
  end

  post "admin/importar_sigaa", to: "admin#importar_sigaa", as: :importar_sigaa
  post "admin/atualizar_sigaa", to: "admin#atualizar_sigaa", as: :atualizar_sigaa

  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
