Rails.application.routes.draw do
  get "home/index"
  # Configurações do Devise
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }, skip: [:registrations]

  resources :cursos, except: [:show]
  resources :disciplinas, except: [:show]
  resources :formularios
  resources :matriculas
  resources :opcoes_pergunta
  resources :pergunta
  resources :resposta
  resources :templates
  resources :turmas
  get "evaluations/index"
  resources :users, except: [:show] do
    member do
      patch :toggle_active
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'home#index'

  # Rotas para a nova página de Avaliações
  get 'evaluations', to: 'evaluations#index'
  get 'evaluations/:id', to: 'evaluations#show', as: :evaluation
  post 'evaluations/:id', to: 'evaluations#show'
  get 'evaluations/:id/results', to: 'evaluations#results', as: :evaluation_results

  # Rotas para disciplinas pessoais (alunos, professores e admin)
  get 'minhas_disciplinas', to: 'minhas_disciplinas#index'
  get 'minhas_disciplinas/:id', to: 'minhas_disciplinas#show', as: :minhas_disciplinas_show
  get 'minhas_disciplinas/:id/gerenciar', to: 'minhas_disciplinas#gerenciar', as: :gerenciar_disciplina
  post 'cadastrar_professor_disciplina', to: 'minhas_disciplinas#cadastrar_professor_disciplina'
  post 'cadastrar_aluno_disciplina', to: 'minhas_disciplinas#cadastrar_aluno_disciplina'

  # Rota administrativa para cadastro de usuários (apenas admins)
  get 'admin/users/new', to: 'admin/users#new', as: :new_admin_user
  post 'admin/users', to: 'admin/users#create', as: :admin_users

  # Rotas administrativas para gerenciamento
  namespace :admin do
    get 'management', to: 'management#index'
    post 'management/import_users', to: 'management#import_users', as: 'management_import_users'
    post 'management/import_disciplines', to: 'management#import_disciplines', as: 'management_import_disciplines'
  end
end
