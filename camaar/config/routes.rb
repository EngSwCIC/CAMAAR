Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "/formularios", to: "formularios#index"

  root to: "home#index"
  devise_for :users

  scope "/turmas" do
    get "/", to: "turmas#index"
    get "/:id", to: "turmas#show"
    # post "/", to: "turmas#create"
    # patch "/:id", to: "turmas#update"
    # delete "/:id", to: "turmas#destroy"
  end

  scope "/matriculas" do
    post "/", to: "matriculas#create"
    delete "/:id", to: "matriculas#delete"
    get "/", to: "matriculas#index"
    # get "/:id", to: "matriculas#show"
    # patch "/:id", to: "matriculas#update"
  end


  resources :formulario
  scope "/formularios" do
    get "/responder", to: "formularios#show_pending"
    get "/responder/:id", to: "formularios#responder"
    post "/responder/:id", to: "formularios#resposta"
  
    get "/", to: "formularios#index"
    get "/:id", to: "formularios#show"
    post "/", to: "formularios#create"
    patch "/:id", to: "formularios#update"
    delete "/:id", to: "formularios#delete"
  end

  scope "/questoes" do
    get "/", to: "questoes#index"
    get "/:id", to: "questoes#show"
    post "/", to: "questoes#create"
    patch "/:id", to: "questoes#update"
    delete "/:id", to: "questoes#delete"
  end

  scope "/respostas" do
    get "/", to: "respostas#index"
    get "/:id", to: "respostas#show"
    post "/", to: "respostas#create"
    patch "/:id", to: "respostas#update"
    delete "/:id", to: "respostas#delete"
  end

  scope "/users" do
    get "/", to: "users#index"
    get "/:id", to: "users#show"
    post "/", to: "users#create"
    patch "/:id", to: "users#update"
    delete "/:id", to: "users#delete"
  end

  resources :templates
  resources :materias
end
