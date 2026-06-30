##
# Gestão das turmas do departamento do administrador logado (issue de gestão
# de turmas). O admin só enxerga/edita turmas do próprio departamento no
# semestre atual.
class ClassesController < ApplicationController
  before_action :authenticate_user!

  CURRENT_SEMESTER = "2026.1".freeze

  ##
  # a. Descrição: Retorna a lista de turmas do departamento do admin no semestre atual.
  # b. Argumentos: Usa a variável de classe CURRENT_SEMESTER.
  # c. Retorno: Sem retorno.
  # d. Efeitos colaterais: Faz a atribuição das turmas do departamento.
  def index
    @semester = CURRENT_SEMESTER
    @turmas = turmas_do_departamento.where(semester: @semester).order(:code)
  end

  ##
  # a. Descrição: Mostra os detalhes de uma turma específica.
  # b. Argumentos: usa o param 'code', que é o código da turma.
  # c. Retorno: Sem retorno.
  # d. Efeitos colaterais: Faz a atribuição dos discentes da turma.
  def show
    @turma = turmas_do_departamento.find_by(code: params[:code])

    if @turma.nil?
      redirect_to classes_path, alert: "Acesso negado: turma fora do seu departamento" and return
    end

    @discentes = @turma.discentes
  end

  ##
  # a. Descrição: Permite a edição de uma turma específica, atualmente apenas o professor.
  # b. Argumentos: Recebe o param 'code', que é o código da turma.
  # c. Retorno: Não há retorno.
  # d. Efeitos colaterais: Redireciona a requisição caso o usuário não tenha permissão.
  def edit
    @turma = turmas_do_departamento.find_by(code: params[:code])
    redirect_to classes_path, alert: "Acesso negado: turma fora do seu departamento" if @turma.nil?
  end

  ##
  # a. Descrição: Atualiza a turma (atualmente apenas o professor).
  # b. Argumentos: Recebe o param 'code', que é o código da turma.
  # c. Retorno: Não há retorno.
  # d. Efeitos colaterais: Redireciona a requisição caso o usuário não tenha permissão ou caso a atualização seja bem-sucedida.
  def update
    @turma = turmas_do_departamento.find_by(code: params[:code])

    if @turma.nil?
      redirect_to classes_path, alert: "Acesso negado: turma fora do seu departamento" and return
    end

    @turma.update(professor: params[:professor])
    redirect_to classes_path, notice: "Turma atualizada com sucesso"
  end

  private

  ##
  # a. Descrição: Retorna a lista de turmas do departamento no semestre atual.
  # b. Argumentos: Usa o atributo 'department' do usuário atual.
  # c. Retorno: Não há retorno.
  # d. Efeitos colaterais: Faz a atribuição das turmas do departamento.
  def turmas_do_departamento
    Turma.do_departamento(current_user.department)
  end
end
