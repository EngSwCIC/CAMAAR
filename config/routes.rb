Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Session management routes
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy", as: :logout

  # Passwords (setup and reset)
  get "usuarios/definir_senha" => "passwords#setup", as: :setup_password
  post "usuarios/definir_senha" => "passwords#setup_update"
  get "usuarios/esqueci_senha" => "passwords#forgot", as: :forgot_password
  post "usuarios/esqueci_senha" => "passwords#forgot_send"
  get "usuarios/redefinir_senha" => "passwords#reset", as: :reset_password
  post "usuarios/redefinir_senha" => "passwords#reset_update"

  # Admin general panel & loader console
  get "admin/dashboard" => "admin#dashboard", as: :admin_dashboard
  post "admin/carregar_dados_teste" => "admin#carregar_dados_teste", as: :carregar_dados_teste
  get "admin/import_console" => "admin#import_console", as: :admin_import_console

  # Admin special department actions
  get "admin/turmas" => "admin#turmas", as: :admin_turmas
  get "admin/turmas/:id/avaliacoes" => "admin#turma_avaliacoes", as: :admin_turma_avaliacoes
  get "admin/desempenho_semestral" => "admin#desempenho_semestral", as: :admin_desempenho_semestral

  # Admin CSV Report
  get "admin/relatorios/csv" => "resultados#export_csv_resultado", as: :admin_relatorios_csv
  get "admin/relatorios" => "resultados#relatorios", as: :admin_relatorios

  # SIGAA Integration
  post "admin/sigaa_import" => "admin#sigaa_import", as: :sigaa_import
  post "admin/sigaa_update" => "admin#sigaa_update", as: :sigaa_update

  # Templates CRUD and endpoints
  resources :templates, only: [ :index, :create, :destroy, :edit, :update ]
  # Formularios (Distribution)
  resources :formularios, only: [ :new, :create ]

  # Resultados (Consolidated reports)
  get "resultados" => "resultados#index", as: :resultados
  get "resultados/:id" => "resultados#show", as: :resultado
  get "resultados/:id/export_csv" => "resultados#export_csv_resultado", as: :export_csv_resultado

  # Avaliacoes (Student prefilling & submittal)
  get "avaliacoes" => "avaliacoes#index", as: :avaliacoes
  get "avaliacoes/:id/responder" => "avaliacoes#new", as: :responder_avaliacao
  post "avaliacoes/:id/responder" => "avaliacoes#create"

  # Root redirection
  root to: "sessions#new"
end
