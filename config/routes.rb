Rails.application.routes.draw do
  resources :questions, only: [], param: :index do
    member do
      delete '(:id)' => "questions#destroy", as: ""
      post '/' => "questions#create"
    end
  end

  resources :templates

  root :to => redirect('/templates')
end