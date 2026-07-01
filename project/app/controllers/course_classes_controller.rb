##
# Apresenta ao administrador as turmas pertencentes ao seu departamento e os
# formulários de avaliação vinculados a cada turma.
class CourseClassesController < ApplicationController
  before_action :require_admin!

  ##
  # Lista as turmas do departamento do administrador no semestre mais recente.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML construída pelo Rails.
  #
  # Efeitos colaterais: consulta o banco e define +@course_classes+ para a view.
  def index
    @course_classes = CourseClass.where(department: current_admin.department, semester: current_semester)
  end

  ##
  # Exibe uma turma e seus formulários, desde que pertença ao departamento do administrador.
  #
  # Não recebe argumentos explícitos; utiliza +params[:id]+.
  #
  # Retorna a resposta HTML ou uma resposta de redirecionamento quando o acesso é negado.
  #
  # Efeitos colaterais: consulta o banco, define variáveis para a view e pode redirecionar
  # para a listagem de turmas com uma mensagem de alerta.
  def show
    @course_class = CourseClass.find(params.expect(:id))

    if @course_class.department_id != current_admin.department_id
      redirect_to course_classes_path, alert: "Acesso negado. Você só pode gerenciar turmas do seu próprio departamento."
      return
    end

    @formularios = Formulario.where(course_class: @course_class)
  end

  private

  ##
  # Determina o semestre mais recente existente na base de turmas.
  #
  # Não recebe argumentos.
  #
  # Retorna o maior valor de +semester+ ou +nil+ quando não há turmas.
  #
  # Efeitos colaterais: consulta o banco de dados.
  def current_semester
    CourseClass.maximum(:semester)
  end
end
