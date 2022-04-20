Rails.application.routes.draw do
  resources :answers
  resources :survey_answers
  resources :likert_questions
  resources :options
  resources :likert_scales
  resources :multiple_choices
  resources :survey_questions
  resources :surveys
  devise_for :user, :path => '/auth', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/template', to:'template#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
