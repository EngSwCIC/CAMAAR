Rails.application.routes.draw do
  # devise_for :admins
  get 'home/index'

  # get 'users/page'
  # get 'users/form_student'
  match '/users/page', to: 'users#page', via: 'get'
  match '/users/forms',   to: 'users#form_student', via: 'get'
  # match '/users/page',   to: 'users#page',   via: 'get'
  # match '/users/page',   to: 'users#page',   via: 'get'
  # match '/admins/login', to: 'admins#login', via: 'get'
  match '/admins/page',   to: 'admins#page', via: 'get'
  match '/admins/forms', to: 'admins#form_student', via: 'get'
  match '/admins/dashboards', to: 'admins#dashboards', via: 'get'
  match '/admins/import', to: 'admins#importdata', via: 'get'

  # get 'admins/page'
  # get 'admins/form_student'
  # get 'admins/importdata'
  # get 'layouts/define_password'
  # devise_for :users

  devise_for :users,
             controllers: {
               registrations: 'users/registrations',
               sessions: 'users/sessions',
               passwords: 'users/passwords',
               confirmations: 'users/confirmations'
             },
             path: 'users',
             path_names: {
               sign_in: 'login',
               sign_up: 'register',
               sign_out: 'logout',
               password: 'recover-password',
               define: 'define-password',
               confirmation: 'verification'
             }

  devise_for :admins,
             controllers: {
               registrations: 'admins/registrations',
               sessions: 'admins/sessions',
               passwords: 'admins/passwords',
               confirmations: 'admins/confirmations'
             },
             path: 'admins',
             path_names: {
               sign_in: 'login',
               sign_up: 'register',
               sign_out: 'logout',
               password: 'recover-password',
               define: 'define-password',
               confirmation: 'verification'
             }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  mount LetterOpenerWeb::Engine, at: '/mails'
  # Defines the root path route ("/")
  # root "posts#index"
  root to: 'home#index'
end
