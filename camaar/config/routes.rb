Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  #cria rotas para os métodos nos controllers de formulários, templates, alunos e turmas
  resources :formularios
  resources :templates
  resources :alunos
  resources :turmas

  # não sei para que isso serve exatamente, mas parece que é
  # para que o devise saiba que existem 2 tipos de users diferentes
  devise_for :aluno
  devise_for :administrador

   # Define a rota para a página de login como a root
  root 'sessions#new'

  # Define a rota para a homepage
  get 'home', to: 'pages#home'
end
