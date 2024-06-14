Rails.application.routes.draw do
  devise_for :users

  get '/avaliacoes', to: 'avaliacoes#index'

  root to: "home#index"
end
