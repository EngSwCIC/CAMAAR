Rails.application.routes.draw do
  resources :templates

  resources :questions, only: [], param: :index do
    member do
      delete '(:id)' => "questions#destroy", as: ""
      post '/' => "questions#create"
    end
  end
end