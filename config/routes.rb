# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "auth#index"

  get "login", to: "auth#index", as: :login
  post "login", to: "auth#login"
  delete "logout", to: "auth#logout", as: :logout

  get "cadastro", to: "auth#solicitar_cadastro", as: :cadastro
  get "cadastro/confirmar", to: "auth#cadastrar", as: :confirmar_cadastro
  post "cadastro", to: "auth#processar_solicitacao_cadastro"
  post "cadastro/confirmar", to: "auth#confirmar_cadastro"

  get "redefinir-senha", to: "auth#solicitar_redef_senha", as: :solicitar_redef_senha
  get "redefinir-senha/confirmar", to: "auth#redefinir_senha", as: :redefinir_senha
  post "redefinir-senha", to: "auth#processar_redefinicao_senha"
  post "redefinir-senha/confirmar", to: "auth#confirmar_redefinicao_senha"

  get "avaliacoes", to: "dashboard#index", as: :avaliacoes
  get "avaliacoes/pendentes", to: "avaliacoes#pendentes", as: :avaliacoes_pendentes
  get "pesquisa", to: "dashboard#pesquisar", as: :pesquisa
  get "pesquisa/sugestoes", to: "dashboard#sugestoes", as: :sugestoes_pesquisa

  resources :avaliacoes, only: [] do
    member do
      get :responder
      post :submeter
    end
  end

  get "gerenciamento", to: "dashboard#gerenciamento", as: :gerenciamento
  post "gerenciamento/importar_dados", to: "dashboard#importar_dados", as: :importar_dados
  post "dashboard/enviar_solicitacoes", to: "dashboard#enviar_solicitacoes", as: :enviar_solicitacoes

  resources :templates

  resources :formularios, only: %i[index show new create] do
    collection do
      post :preparar
      get :publicar
    end

    member do
      get :exportar_csv
    end
  end
end
