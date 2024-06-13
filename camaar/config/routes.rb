Rails.application.routes.draw do
  get "home/index"

  match "/errors/forbidden", to: "errors#forbidden", via: "get"

  # get "/forms", to: "forms#index", via: "get"
  # get "/classes", to: "subject_clasess#index"
  # get "/results", to: "results#index"
  # get "/import", to: "admins#import"
  # get "/dispatch", to: "admins#dispatch"

  match "/users/page", to: "users#page", via: "get"
  match "/errors/forbidden", to: "errors#forbidden", via: "get"
  # match "/users/forms", to: "users#form_student", via: "get"
  # post "/answers", to: "student_answers#create"

  scope "users" do
    resources :answers, only: [:create]
    resources :forms, only: [:index,:edit]
  end
  scope "admins" do
    resources :templates do
      resources :template_questions
    end

    # match '/admins/forms', to: 'admins#form_student', via: 'get'
    match "/results", to: "admins#resultados", via: "get"
    # match "/templates", to: "admins#create_template", via: "get"
    match "/classes", to: "subject_classes#index", via: "get"

    match "/import", to: "admins#importdata", via: "get", as: "admins_import"
    match "/import", to: "admins#import", via: "post", as: "admins_import_post"

    # match '/admins/envio', to: 'forms#new', via: 'get'
    match "/envio", to: "admins#envio", via: "get"
    match "/envio", to: "admins#envio", via: "post", as: "admins_envio_post"
  end

  devise_scope :user do
    get "/users/logout" => "users/sessions#destroy"
    post "/users/register" => "users/registrations#create"
    post "/users/recover-password/new" => "users/passwords#create"
  end

  devise_scope :admin do
    get "/admins/logout" => "admins/sessions#destroy"
    post "/admins/register" => "admins/registrations#create"
    post "/admins/recover-password/new" => "admins/passwords#create"
  end

  devise_for :users,
             controllers: {
               registrations: "users/registrations",
               sessions: "users/sessions",
               passwords: "users/passwords",
               confirmations: "users/confirmations",
             },
             path: "users",
             path_names: {

               sign_in: "login",
               sign_up: "register",
               sign_out: "logout",
               password: "recover-password",
               confirmation: "verification",

             }

  devise_for :admins,
             controllers: {
               registrations: "admins/registrations",
               sessions: "admins/sessions",
               passwords: "admins/passwords",
               confirmations: "admins/confirmations",
             },
             path: "admins",
             path_names: {

               sign_in: "login",
               sign_up: "register",
               sign_out: "logout",
               password: "recover-password",
               confirmation: "verification",

             }

  get "up" => "rails/health#show", as: :rails_health_check
  mount LetterOpenerWeb::Engine, at: "/mails"
  # Defines the root path route ("/")
  # root "posts#index"
  root to: "home#index"
end
