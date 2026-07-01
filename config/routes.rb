Rails.application.routes.draw do
  root "sessions#new"
  
  get "home/index"

  get "login", to: "sessions#new", as: "/"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: "logout"

  get "/home", to: "home#index", as: "home"

  get  'definir-senha/:token', to: 'password_sets#new',    as: 'password_set'
  patch 'definir-senha/:token', to: 'password_sets#update'

  resources :templates

  post "/sigaa/update",
     to: "sigaa#update_database"

  namespace :admin do
    resources :imports, only: [:index, :create]
    get  "management",          to: "management#index",   as: "management"
    get  "results",             to: "results#index",      as: "results"
    resources :results, only: [:show] do
      member { get :csv }
    end
    resources :templates, only: [:index, :create, :update, :destroy]
    resources :forms,     only: [:index, :create]
  end

  get  "avaliacoes",          to: "avaliacoes#index",    as: "avaliacoes"
  get  "avaliacoes/:id/detalhes", to: "avaliacoes#detalhes", as: "detalhes_avaliacao"
  get  "avaliacoes/:id",      to: "avaliacoes#show",     as: "avaliacao"
  post "avaliacoes/:id/responder", to: "avaliacoes#responder", as: "responder_avaliacao"

  get   "esqueci-senha",          to: "password_resets#new",    as: "new_password_reset"
  post  "esqueci-senha",          to: "password_resets#create", as: "password_resets"
  get   "redefinir-senha/:token", to: "password_resets#edit",   as: "password_reset"
  patch "redefinir-senha/:token", to: "password_resets#update"

  get "/favicon.ico", to: proc { [204, {}, []] }
end
