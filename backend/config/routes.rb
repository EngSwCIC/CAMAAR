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
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/import/turmas', to: 'scrapper#show'
  get '/turmas', to: 'cclasses#index'
end
