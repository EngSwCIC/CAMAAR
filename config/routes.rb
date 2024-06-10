Rails.application.routes.draw do
  root "index#index"
  get '/login', to: 'authentication#new'
end
