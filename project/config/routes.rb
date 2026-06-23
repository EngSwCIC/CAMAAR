Rails.application.routes.draw do
  resources :resposta
  resources :submissaos
  resources :questaos

  resources :formularios do
    member do
      get :exportar_csv
    end
  end

  resources :templates

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#show"

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "senha/definir/:token", to: "password_setups#edit", as: :edit_password_setup
  patch "senha/definir/:token", to: "password_setups#update", as: :password_setup

  get "senha/esqueci", to: "password_resets#new", as: :new_password_reset
  post "senha/esqueci", to: "password_resets#create", as: :password_resets
  get "senha/redefinir/:token", to: "password_resets#edit", as: :edit_password_reset
  patch "senha/redefinir/:token", to: "password_resets#update", as: :password_reset

  namespace :imports do
    get "sigaa", to: "sigaa#new"
    post "sigaa", to: "sigaa#create"
  end
end
