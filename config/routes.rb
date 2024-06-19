Rails.application.routes.draw do
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

  get 'formulario_templates/index'
  get 'formulario_templates/edit_template', to: 'formulario_templates#edit_template', as: 'edit_template'
  root 'formulario_templates#index'

  delete 'delete_file', to: 'formulario_templates#delete_file'
  get 'view_file', to: 'formulario_templates#view_file'

  get 'templates/check_name', to: 'templates#check_name'

  post 'materia/search_in_sigaa'
  post 'materia/update_with_sigaa_data'

  resources :reports_professors
  resources :reports_alunos
  resources :formulario_templates
  resources :formularios
  resources :departamentos
  resources :materia
  devise_for :professors
  devise_for :alunos
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
