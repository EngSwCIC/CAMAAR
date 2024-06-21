Rails.application.routes.draw do
  devise_for :users

  # get '/avaliacoes', to: 'avaliacoes#index'

  resources :avaliacoes, only: [:index, :show] do
    resources :response, only: [:show, :create, :update, :destroy]
  end

  get '/gerenciamento', to: 'gerenciamento#index'
  put '/gerenciamento/import', :as => 'gerenciamento_import'

  root to: "avaliacoes#index"
end
