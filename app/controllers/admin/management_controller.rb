# Controller da página principal de gerenciamento do administrador
class Admin::ManagementController < ApplicationController
  before_action :require_admin
  layout "dashboard"

  # Exibe o painel de gerenciamento com botões de ação
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum (renderiza view)
  # Efeitos colaterais: Nenhum
  def index
    @turmas     = Turma.includes(:disciplina).all
    @templates  = Template.order(:nome)
  end
end
