Rails.application.routes.draw do
  resources :usuarios do 
    post 'getJson', on: :collection
  end
  resources :sessions

  root 'sessions#new'
  get 'gerenciamento', to: 'gerenciamento#show'
  get 'gerenciamento/templates', to: 'gerenciamento#show_templates'
  get '/definir-senha/:id', to: 'auth#define_password'
  get '/runner/add', to: 'runner#add'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
