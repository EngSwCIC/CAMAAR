Rails.application.routes.draw do
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  #cria rotas para os métodos nos controllers de formulários, templates, alunos e turmas
  resources :formularios
  resources :templates
  resources :alunos
  resources :turmas
  resources :tipos

  # Define a rota para a página de login como a root
  devise_scope :user do
    root to: "devise/sessions#new"
    get 'change_password', to: 'devise/passwords#edit', as: :change_password
    # get 'users/change_password', to: 'devise/passwords#edit', as: :change_password
  end

  # Define a rota para a homepage de users do tipo aluno e adm
  get 'home_dicente', to: 'pages#home_dicente'
  get 'home_docente', to: 'pages#home_docente'

  # Define a rota para edição de senha
  #get 'password', to: ''
end
