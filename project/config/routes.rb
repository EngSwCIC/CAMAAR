Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "dashboard#show"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "senha/definir/:token", to: "password_setups#edit", as: :edit_password_setup
  patch "senha/definir/:token", to: "password_setups#update", as: :password_setup

  get "senha/esqueci", to: "password_resets#new", as: :new_password_reset
  post "senha/esqueci", to: "password_resets#create", as: :password_resets
  get "senha/redefinir/:token", to: "password_resets#edit", as: :edit_password_reset
  patch "senha/redefinir/:token", to: "password_resets#update", as: :password_reset

  namespace :imports do
    post "class_members", to: "class_members#create"
  end
end
