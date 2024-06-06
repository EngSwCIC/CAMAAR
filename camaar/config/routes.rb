Rails.application.routes.draw do
  get 'home/index'

  match '/users/page', to: 'users#page', via: 'get'
  match '/errors/forbidden', to: 'errors#forbidden', via: 'get'

  match '/users/forms',   to: 'users#form_student', via: 'get'
  match '/admins/page',   to: 'admins#page', via: 'get'
  match '/admins/forms', to: 'admins#form_student', via: 'get'
  match '/admins/resultados', to: 'admins#resultados', via: 'get'
  match '/admins/templates', to: 'admins#create_template', via: 'get'
  match '/admins/turmas', to: 'admins#turmas', via: 'get'

  match '/admins/import', to: 'admins#importdata', via: 'get'
  match '/admins/envio', to: 'admins#envio', via: 'get'

  post '/admins/import', to: 'admins#import'

  devise_scope :user do
    get '/users/logout' => 'users/sessions#destroy'
    post '/users/register' => 'users/registrations#create'
    post '/users/recover-password/new' => 'users/passwords#create'
  end

  devise_scope :admin do
    get '/admins/logout' => 'admins/sessions#destroy'
    post '/admins/register' => 'admins/registrations#create'
    post '/admins/recover-password/new' => 'admins/passwords#create'
  end

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

  get 'up' => 'rails/health#show', as: :rails_health_check
  mount LetterOpenerWeb::Engine, at: '/mails'
  # Defines the root path route ("/")
  # root "posts#index"
  root to: 'home#index'
end
