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

  # Rota para visualizar os resultados de um formulário
  get '/formularios/:id', to: 'formularios#show', as: 'resultados_formulario'

  # Rota para responder um formulário
  get '/formularios/:id/responder', to: 'formularios#responder', as: 'responder_formulario'

  #cria rotas para os métodos nos controllers de formulários, templates, alunos e turmas
  resources :templates
  resources :formularios
  resources :docentes
  resources :dicentes
  resources :tipos

  resources :turmas do
    collection do
      get :import
      post :import
    end
  end

  resources :disciplinas do
    collection do
      get :import
      post :import
    end
  end

  # Define a rota para a página de login como a root
  devise_scope :user do
    root to: "devise/sessions#new"
    get 'users/change_password', to: 'devise/passwords#edit', as: :change_password
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Define a rota para a homepage de users do tipo aluno e adm
  get 'home_dicente', to: 'pages#home_dicente'
  get 'home_docente', to: 'pages#home_docente'
end
