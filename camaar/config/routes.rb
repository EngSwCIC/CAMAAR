Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "/user", to: "user#index"
  get "/login", to: "user#login"
  get "/admin/departments/:id", to: "departments#show"

  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  root "user#login"
end
