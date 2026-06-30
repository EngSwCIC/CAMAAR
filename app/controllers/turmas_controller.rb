##
# Listagem das turmas para usuários autenticados.
class TurmasController < ApplicationController
  before_action :authenticate_user!

  ##
  # a. Descrição: Lista todas as turmas cadastradas, ordenadas por código.
  # b. Argumentos: Nenhum.
  # c. Retorno: Não há retorno.
  # d. Efeitos colaterais: Atribui a variável de instância @turmas.
  def index
    @turmas = Turma.do_departamento(current_user.department).order(:code)
  end
end
