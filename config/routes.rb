Rails.application.routes.draw do
  devise_for :users

  # get '/avaliacoes', to: 'avaliacoes#index'

  resources :avaliacoes, only: [:index] do
    resources :response, only: [:index, :create, :update, :destroy]
  end

  get '/gerenciamento', to: 'gerenciamento#index'
  put '/gerenciamento/import', :as => 'gerenciamento_import'

  root to: "avaliacoes#index"
end
