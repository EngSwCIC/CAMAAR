Rails.application.routes.draw do
  # Auth Paths
  get '/login', to: 'authentication#login', as: 'login'
  get '/check_authentication', to: 'authentication#check_authentication'
  post '/process_login', to: 'authentication#process_login'
  post '/logout' => 'authentication#logout', as: :logout
  # Registrations Paths
  get '/create', to: 'registrations#index', as: 'create'
  post '/create', to: 'registrations#create', as: 'register'
  # Root Path
  root 'index#index'
  # Redifine Password Path
  get '/redefine_password', to: 'redefine_password#index', as: 'redefine_password'
  post '/redefine_password', to: 'redefine_password#redefine', as: 'redefine_password_post'
  # Manager Path
  get '/manager', to: 'manager#index', as: 'manager'
  # Sigaa Management Path
  post '/import_sigaa_data', to: 'sigaa_management#import_sigaa_data', as: 'import_from_sigaa'
  post '/update_sigaa_data', to: 'sigaa_management#update_sigaa_data', as: 'update_sigaa_data'
  post '/send_email_availables_sign_up', to: 'sigaa_management#send_email_availables_sign_up',
                                         as: 'send_email_availables_sign_up'
  # Semesters Path
  get '/semesters', to: 'semesters#index'
  get '/semesters/current', to: 'semesters#show'
  # Evaluations Path
  get '/disciplines', to: 'evaluations#disciplines', as: 'disciplines'
  get '/evaluations', to: 'evaluations#index', as: 'evaluations'
  get '/evaluations/:id', to: 'evaluations#show'

  # Templates/forms
  resources :templates do
    get 'send', to: 'templates#edit_send', on: :collection, as: :to_send
    member do
      post 'send', to: 'templates#send_out_forms', as: :send_forms_from
    end
  end
  resources :forms

  resources :questions, only: [], param: :index do
    member do
      delete '(:id)' => 'questions#destroy', as: ''
      post '/' => 'questions#create'
    end
  end
end
