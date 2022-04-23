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

  # Rotas dos questionarios
  get '/surveys/:id', to: "surveys#show"

  # Turmas de um usuario/membro
  get '/member_classes/:member_id', to: "cclasses#member_classes"
end
