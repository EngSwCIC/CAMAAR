Rails.application.routes.draw do
  resources :turmas, only: [ :index ]
  devise_for :users

  resources :users, only: [ :index, :new, :create ] do
    collection do
      post :import
      get :sigaa
      post :sigaa_import
      post :register_participants
    end
  end

  # Aliases em português usados pelos cenários de cadastro de usuário
  get "/usuarios", to: "users#index"
  get "/usuarios/novo", to: "users#new"

  # Definição de senha do participante importado via SIGAA
  get "/users/password/define", to: "pending_registrations#edit"
  post "/users/password/define", to: "pending_registrations#update"

  # Redefinição de senha a partir do link enviado por e-mail
  get "/password/edit", to: "password_redefinition#edit"
  post "/password/update", to: "password_redefinition#update"

  # Atualização da base com dados atuais do SIGAA
  get "/sigaa/atualizar", to: "sigaa_updates#new"
  post "/sigaa/atualizar", to: "sigaa_updates#create"

  # Gestão de turmas do departamento
  get "/classes", to: "classes#index"
  get "/classes/:code/edit", to: "classes#edit", as: :edit_class
  get "/classes/:code", to: "classes#show", as: :class
  patch "/classes/:code", to: "classes#update"

  # Resultados de um formulário e download em CSV por slug
  get "/resultados/:slug/download", to: "resultados#download"
  get "/resultados/:slug", to: "resultados#show", as: :resultado

  resources :templates

  resources :formularios do
    member do
      get :relatorio
    end
    resources :respostas, only: [ :create ]
  end

  # Alias usado pelos cenários (visita "/forms")
  get "/forms", to: "formularios#index"

  root "users#index"
end
