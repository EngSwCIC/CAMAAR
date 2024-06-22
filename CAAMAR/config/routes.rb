Rails.application.routes.draw do
  resources :usuarios do 
    post 'getJson', on: :collection
  end
  resources :sessions

  root 'sessions#new'

  get '/definir-senha/:id', to: 'auth#define_password'
  get '/runner/add', to: 'runner#add'

  get 'gerenciamento', to: 'gerenciamento#index'
  get 'gerenciamento/templates', to: 'gerenciamento#show_templates'
  get 'gerenciamento/results_popup'
  get 'gerenciamento/generate_csv'

  get 'turmas', to: 'turmas#index'

  get 'avaliacoes', to: 'avaliacoes#index'
  
  get 'uploader', to: 'uploader#index'

  get 'template', to: 'template#index'
  get 'getemps', to: 'gerenciamento#show_templates'
  get 'template/edit', to: 'template#edit'
  get 'edit_template', to: 'template#edit_template', as: 'edit_template'

  post 'edit_template', to: 'template#edit'

  post 'delete_template', to: 'template#delete_template', as: 'delete_template'

  # resource to read json files
  resources :jsonfiles do
    collection do
      post :import
    end
  end

  # resource to create forms
  resource :formcreates do
    collection do
        post :import
    end
  end

  # resource to suposebly create template
  resource :templatecreates do
    collection do
      post :import
    end
  end

  resource :template do
    collection do
      post :edit
    end
  end

  #
  get 'forms_answer/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'forms_answer/new/:form_id/:solver_id', to: 'forms_answer#new'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  post '/import_formanswercreates', to: 'forms_answer#create', as: 'import_formanswercreates'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
