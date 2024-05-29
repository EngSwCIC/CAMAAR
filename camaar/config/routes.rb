Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/classes/:department_initials", to: "classes#index", as: :department_classes
  get "/import", to: "classes#create", as: :import_classes
  get "/results", to: "answers#index"
  get "/dispatch", to: "forms#create"

  resources :templates
  get "/forms", to: "forms#index"
  get "/forms/:id", to: "forms#edit"
end
