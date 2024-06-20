Rails.application.routes.draw do
  resources :usuarios do 
    post 'getJson', on: :collection
  end
  resources :sessions

  root 'sessions#new'
  get 'gerenciamento', to: 'gerenciamento#index'
  get 'gerenciamento/templates', to: 'gerenciamento#show_templates'
  get '/definir-senha/:id', to: 'auth#define_password'
  get '/runner/add', to: 'runner#add'
  root 'auth#login'
  get 'main/index'
  get 'gerenciamento', to: 'gerenciamento#show'
  get 'gerenciamento/results_popup'

  get 'turmas', to: 'turmas#index'

  get 'avaliacoes', to: 'avaliacoes#index'

  # resource to read json files
  get 'uploader', to: 'uploader#index'

  resources :jsonfiles do
    collection do
      post :import
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
