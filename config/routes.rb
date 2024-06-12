Rails.application.routes.draw do
  get '/create', to: 'registrations#index', as: 'create'
  post '/create', to: 'registrations#create', as: 'register'
  get '/login', to: 'authentication#login', as: 'login'
  get '/check_authentication', to: 'authentication#check_authentication'
  post '/process_login', to: 'authentication#process_login'
  get '/home', to: 'home#index', as: 'home'
  root "index#index"

  resources :questions, only: [], param: :index do
    member do
      delete '(:id)' => "questions#destroy", as: ""
      post '/' => "questions#create"
    end
  end

  resources :templates

  root :to => redirect('/templates')
end