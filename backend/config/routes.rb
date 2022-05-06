Rails.application.routes.draw do
  devise_for :user, :path => '/auth', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  post '/users', to: 'users#create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
