Rails.application.routes.draw do
  post 'save_template', to: 'templates#save_template'

  get 'formulario_templates/index'
  get 'formulario_templates/edit_template', to: 'formulario_templates#edit_template', as: 'edit_template'
  root 'formulario_templates#index'

  delete 'delete_file', to: 'formulario_templates#delete_file'
  get 'view_file', to: 'formulario_templates#view_file'

  get 'templates/check_name', to: 'templates#check_name'

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
