Rails.application.routes.draw do
  get 'member/show'
  resources :surveys do
    get 'open', on: :collection
  end
  resources :members, only: [:show] do 
    resources :cclasses, only: [:index]
  end
  resources :survey_answers, only: [:create]
  devise_for :user, :path => '/auth', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/template', to:'template#show'
  post '/import/turmas', to:'scrapper#index'
  
  post '/users', to: 'users#create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/import/turmas', to: 'scrapper#show'
  get '/turmas', to: 'cclasses#index'
  # classes
  get '/cclasses', to:'cclasses#index'
  get '/cclasses/:id', to:'cclasses#show'
  get '/cclasses/:id/members', to:'members#index'
  get '/cclasses/cclass_grade/:id', to:'cclasses#class_grade'
  # subjects
  get '/subjects', to:'subjects#index'
  get '/subjects/:id', to:'subjects#show'

  # members
  get '/members', to:'members#index'
  get '/members/:id', to:'members#show'

  #member_cclasses
  scope '/member_cclasses/' do
    get 'index', to: 'member_cclasses#index'
    post 'create', to: 'member_cclasses#create'
    delete 'destroy/:id', to: 'member_cclasses#destroy'
  end

end
