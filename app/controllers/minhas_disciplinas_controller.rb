# frozen_string_literal: true

class MinhasDisciplinasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_disciplinas, only: [:index]

  def index
    case current_user.role
    when 'aluno'
      # Disciplinas em que o aluno está matriculado
      @disciplinas = Disciplina.joins(turmas: :matriculas)
                              .where(matriculas: { user_id: current_user.id })
                              .includes(:curso, turmas: [:professor, :matriculas])
                              .distinct
      @page_title = "Minhas Disciplinas - Aluno"
      @user_type = "aluno"
    when 'professor'
      # Disciplinas que o professor leciona
      @disciplinas = Disciplina.joins(:turmas)
                              .where(turmas: { professor_id: current_user.id })
                              .includes(:curso, :turmas)
                              .distinct
      @page_title = "Minhas Disciplinas - Professor"
      @user_type = "professor"
    when 'admin'
      # Admin pode ver todas as disciplinas
      @disciplinas = Disciplina.includes(:curso, :turmas).all
      @page_title = "Todas as Disciplinas - Administrador"
      @user_type = "admin"
    else
      redirect_to root_path, alert: 'Acesso negado.'
    end
  end

  def show
    @disciplina = Disciplina.find(params[:id])
    
    # Verificar se o usuário tem acesso à disciplina
    case current_user.role
    when 'aluno'
      unless current_user.matriculas.joins(:turma).where(turmas: { disciplina_id: @disciplina.id }).exists?
        redirect_to minhas_disciplinas_path, alert: 'Você não tem acesso a esta disciplina.'
        return
      end
      @turmas = @disciplina.turmas.joins(:matriculas).where(matriculas: { user_id: current_user.id }).includes(:professor)
    when 'professor'
      unless @disciplina.turmas.where(professor_id: current_user.id).exists?
        redirect_to minhas_disciplinas_path, alert: 'Você não leciona esta disciplina.'
        return
      end
      @turmas = @disciplina.turmas.where(professor_id: current_user.id).includes(:matriculas, :alunos)
    when 'admin'
      @turmas = @disciplina.turmas.includes(:professor, :matriculas, :alunos)
    end
  end

  def gerenciar
    # Página administrativa para cadastro manual
    redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?
    
    @disciplinas = Disciplina.includes(:curso, :turmas).all
    @cursos = Curso.all
    @professores = User.where(role: 'professor')
    @alunos = User.where(role: 'aluno')
    @disciplina = Disciplina.new
    @turma = Turma.new
  end

  def cadastrar_professor_disciplina
    redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?
    
    @disciplina = Disciplina.find(params[:disciplina_id])
    @professor = User.find(params[:professor_id])
    
    # Verificar se já existe uma turma para este professor nesta disciplina no semestre
    semestre = params[:semestre]
    
    if @disciplina.turmas.where(professor_id: @professor.id, semestre: semestre).exists?
      redirect_to gerenciar_disciplinas_path, alert: 'Este professor já leciona esta disciplina neste semestre.'
      return
    end
    
    @turma = @disciplina.turmas.create!(
      professor: @professor,
      semestre: semestre
    )
    
    redirect_to gerenciar_disciplinas_path, notice: "Professor #{@professor.name} cadastrado na disciplina #{@disciplina.nome} para o semestre #{semestre}."
  end

  def cadastrar_aluno_disciplina
    redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?
    
    @turma = Turma.find(params[:turma_id])
    @aluno = User.find(params[:aluno_id])
    
    # Verificar se o aluno já está matriculado nesta turma
    if @aluno.matriculas.where(turma_id: @turma.id).exists?
      redirect_to gerenciar_disciplinas_path, alert: 'Este aluno já está matriculado nesta turma.'
      return
    end
    
    @matricula = @aluno.matriculas.create!(turma: @turma)
    
    redirect_to gerenciar_disciplinas_path, notice: "Aluno #{@aluno.name} matriculado na turma #{@turma.disciplina.nome} - #{@turma.semestre}."
  end

  private

  def set_user_disciplinas
    @user_disciplinas_count = case current_user.role
                             when 'aluno'
                               current_user.matriculas.joins(:turma).distinct.count('turmas.disciplina_id')
                             when 'professor'
                               current_user.turmas_como_professor.joins(:disciplina).distinct.count('disciplinas.id')
                             when 'admin'
                               Disciplina.count
                             else
                               0
                             end
  end
end
