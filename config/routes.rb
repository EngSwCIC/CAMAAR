Rails.application.routes.draw do
  devise_for :users

  get '/avaliacoes', to: 'avaliacoes#index'

  scope :avaliacoes do
    resources :response, only: [:show, :show, :create, :destroy]
  end

  get '/gerenciamento', to: 'gerenciamento#index'
  put '/gerenciamento/import', :as => 'gerenciamento_import'

  root to: "avaliacoes#index"
end
