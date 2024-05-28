Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "/classes/:department_initials", to: "classes#index", as: :department_classes
  # root "auth/login#index"
end
