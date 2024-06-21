Rails.application.routes.draw do
  devise_for :users

  resources :avaliacoes, only: [:index] do
    resources :response, only: [:index, :create, :update, :destroy]
  end

  resources :templates

  get '/gerenciamento', to: 'gerenciamento#index'
  put '/gerenciamento/import', :as => 'gerenciamento_import'

  get '/gerenciamento/resultados', :to => 'resultados#index'

  get '/send_forms', to: 'send_forms#index'

  root to: "avaliacoes#index"
end
