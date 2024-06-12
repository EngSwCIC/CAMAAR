Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :users

  #cria rotas para os métodos nos controllers de formulários, templates, alunos e turmas
  resources :formularios
  resources :templates
  resources :alunos
  resources :turmas

  # Define a rota para a página de login como a root
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # Define a rota para a homepage de users do tipo aluno e adm
  get 'home_dicente', to: 'pages#home_dicente'
  get 'home_docente', to: 'pages#home_docente'
end
