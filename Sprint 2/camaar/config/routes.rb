Rails.application.routes.draw do
  resources :templates
  resources :avaliacoes, only: [:index, :new, :create, :show] do
    member do
      get  :responder
      post :submeter
      get  :resultados
      get :exportar_csv
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  get "up" => "rails/health#show", as: :rails_health_check

  get 'dashboard', to: 'dashboard#index', as: :dashboard
  post 'import_data', to: 'import_data#import', as: :import_data

  namespace :admin do
    resources :users, only: [] do
      collection do
        post :import
      end
    end
    resources :turmas, only: [:index]
  end

  devise_scope :user do
    root "users/sessions#new"
  end
end