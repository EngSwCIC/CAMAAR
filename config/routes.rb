Rails.application.routes.draw do
  resources :turmas, only: [:index]
  devise_for :users

  resources :users, only: [:index, :new] do
    collection do
      post :import
      get :sigaa
      post :sigaa_import
    end
  end

  resources :templates

  resources :formularios do
    member do
      get :relatorio
    end
    resources :respostas, only: [:create]
  end

  root "users#index"
end