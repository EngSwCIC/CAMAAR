# config/routes.rb
Rails.application.routes.draw do
  get    "/login",  to: "sessoes#new",     as: :login
  post   "/login",  to: "sessoes#create"
  delete "/logout", to: "sessoes#destroy", as: :logout

  get   "/usuarios/mudar-senha", to: "usuarios#mudar_senha",    as: :mudar_senha
  patch "/usuarios/mudar-senha", to: "usuarios#atualizar_senha"

  # Issue #8 — listar e visualizar formulários (discente)
  resources :formularios, only: [:index, :show] do
    member do
      get :minha_resposta
    end
  end

  # Issue #18 — responder formulário (discente)
  resources :envio_formularios, only: [:new, :create]

  root to: "dashboard#index"
end
