Rails.application.routes.draw do

  devise_for :professors, controllers: {
    sessions: 'professors/sessions'
  }
  devise_for :alunos, controllers: {
    sessions: 'alunos/sessions'
  }

  get 'home/index'


  authenticated :aluno do
    root 'alunos#dashboard', as: :authenticated_aluno_root
  end

  authenticated :professor do
    root 'professors#dashboard', as: :authenticated_professor_root
  end

  root "home#index"



  get 'get_response_files', to: 'formularios#get_response_files'
  get 'list_json_files', to: 'formularios#list_json_files'

  get 'count_responses', to: 'formularios#count_responses'


  post 'submit_form', to: 'reports_alunos#submit_form'

  resources :formularios do
    collection do
      post :save_formulario
    end
  end

  get 'reports_alunos/formularios', to: 'reports_alunos#formularios'
  get 'fetch_form', to: 'reports_alunos#fetch_form'

  get 'view_file_form', to: 'formularios#view_file_form'
  delete 'delete_file_form', to: 'formularios#delete_file_form'
  # Adicione a rota para criação de novos formulários se necessário
  get 'new_formulario', to: 'formularios#new'
  get 'formularios', to: 'formularios#index'
  
  resources :formularios
  post 'save_formulario', to: 'formularios#save_formulario'

  post 'save_template', to: 'templates#save_template'

  get 'formulario_templates/index'
  get 'formulario_templates/edit_template', to: 'formulario_templates#edit_template', as: 'edit_template'


  delete 'delete_file', to: 'formulario_templates#delete_file'
  get 'view_file', to: 'formulario_templates#view_file'

  get 'templates/check_name', to: 'templates#check_name'

  resources :reports_professors
  resources :reports_alunos
  resources :formulario_templates do
    get 'edit', on: :member
  end
  resources :formularios
  resources :departamentos
  resources :materia
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
