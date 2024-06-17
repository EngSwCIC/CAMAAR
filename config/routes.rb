Rails.application.routes.draw do
  # Auth Paths
  get '/login', to: 'authentication#login', as: 'login'
  get '/check_authentication', to: 'authentication#check_authentication'
  post '/process_login', to: 'authentication#process_login'
  post '/logout' => 'authentication#logout', as: :logout
  # Registrations Paths 
  get '/create', to: 'registrations#index', as: 'create'
  post '/create', to: 'registrations#create', as: 'register'
  # Home Paths  
  get '/home', to: 'home#index', as: 'home'
  # Root Path
  root "index#index"
  
  resources :templates

  resources :questions, only: [], param: :index do
    member do
      delete '(:id)' => "questions#destroy", as: ""
      post '/' => "questions#create"
    end
  end
end