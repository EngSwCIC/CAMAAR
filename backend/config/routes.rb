Rails.application.routes.draw do
  devise_for :user, :path => '/auth', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/template', to:'template#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # classes
  get '/cclasses', to:'cclasses#index'
  get '/cclasses/:id', to:'cclasses#show'
  get '/cclasses/:id/members', to:'members#index'

  # subjects
  get '/subjects', to:'subjects#index'
  get '/subjects/:id', to:'subjects#show'

  # members
  get '/members', to:'members#index'
  get '/members/:id', to:'members#show'

end
