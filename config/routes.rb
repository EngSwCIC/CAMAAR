Rails.application.routes.draw do
  devise_for :users

  resources :avaliacoes, only: [:index] do
    resources :response, only: [:index, :create, :update, :destroy]
  end

  get '/gerenciamento', to: 'gerenciamento#index'
  put '/gerenciamento/import', :as => 'gerenciamento_import'

  get '/gerenciamento/resultados', :to => 'resultados#index'
  get '/gerenciamento/resultados/:id/export', :to => 'resultados#export', :as => "resultados_export"

  root to: "avaliacoes#index"
end
