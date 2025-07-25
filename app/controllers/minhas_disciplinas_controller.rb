# frozen_string_literal: true

# Controller para gerenciar as disciplinas de um usuário.
class MinhasDisciplinasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_disciplinas, only: [:index]

  # GET /minhas_disciplinas
  #
  # Lista as disciplinas do usuário atual com base em seu papel.
  #
  def index
    case current_user.role
    when 'aluno'
      # Disciplinas em que o aluno está matriculado
      @disciplinas = Disciplina.joins(turmas: :matriculas)
                               .where(matriculas: { user_id: current_user.id })
                               .includes(:curso, turmas: %i[professor matriculas])
                               .distinct
      @page_title = 'Minhas Disciplinas - Aluno'
      @user_type = 'aluno'
    when 'professor'
      # Disciplinas que o professor leciona
      @disciplinas = Disciplina.joins(:turmas)
                               .where(turmas: { professor_id: current_user.id })
                               .includes(:curso, :turmas)
                               .distinct
      @page_title = 'Minhas Disciplinas - Professor'
      @user_type = 'professor'
    when 'admin'
      # Admin pode ver todas as disciplinas
      @disciplinas = Disciplina.includes(:curso, :turmas).all
      @page_title = 'Todas as Disciplinas - Administrador'
      @user_type = 'admin'
    else
      redirect_to root_path, alert: 'Acesso negado.'
    end
  end

  # GET /minhas_disciplinas/:id
  #
  # Exibe os detalhes de uma disciplina específica.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da disciplina.
  #
  def show
    @disciplina = Disciplina.find(params[:id])

    # Verificar se o usuário tem acesso à disciplina
    case current_user.role
    when 'aluno'
      unless current_user.matriculas.joins(:turma).exists?(turmas: { disciplina_id: @disciplina.id })
        redirect_to minhas_disciplinas_path, alert: 'Você não tem acesso a esta disciplina.'
        return
      end
      @turmas = @disciplina.turmas
                           .joins(:matriculas)
                           .where(matriculas: { user_id: current_user.id })
                           .includes(:professor)
    when 'professor'
      unless @disciplina.turmas.exists?(professor_id: current_user.id)
        redirect_to minhas_disciplinas_path, alert: 'Você não leciona esta disciplina.'
        return
      end
      @turmas = @disciplina.turmas.where(professor_id: current_user.id).includes(:matriculas, :alunos)
    when 'admin'
      @turmas = @disciplina.turmas.includes(:professor, :matriculas, :alunos)
    end
  end

  # GET /minhas_disciplinas/gerenciar
  #
  # Exibe a página de gerenciamento de disciplinas para administradores.
  #
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

  # POST /minhas_disciplinas/cadastrar_professor_disciplina
  #
  # Cadastra um professor em uma disciplina.
  #
  # ==== Attributes
  #
  # * +disciplina_id+ - O ID da disciplina.
  # * +professor_id+ - O ID do professor.
  # * +semestre+ - O semestre da turma.
  #
  # ==== Side Effects
  #
  # * Cria uma nova turma para o professor na disciplina.
  # * Redireciona para a página de gerenciamento.
  #
  def cadastrar_professor_disciplina
    redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @disciplina = Disciplina.find(params[:disciplina_id])
    @professor = User.find(params[:professor_id])

    # Verificar se já existe uma turma para este professor nesta disciplina no semestre
    semestre = params[:semestre]

    if @disciplina.turmas.exists?(professor_id: @professor.id, semestre: semestre)
      redirect_to gerenciar_disciplina_path(@disciplina),
                  alert: 'Este professor já leciona esta disciplina neste semestre.'
      return
    end

    @turma = @disciplina.turmas.create!(
      professor: @professor,
      semestre: semestre
    )

    professor_name = @professor.name
    disciplina_nome = @disciplina.nome
    redirect_to gerenciar_disciplina_path(@disciplina),
                notice: "Professor #{professor_name} cadastrado na disciplina #{disciplina_nome} para o semestre #{semestre}."
  end

  # POST /minhas_disciplinas/cadastrar_aluno_disciplina
  #
  # Cadastra um aluno em uma turma.
  #
  # ==== Attributes
  #
  # * +turma_id+ - O ID da turma.
  # * +aluno_id+ - O ID do aluno.
  #
  # ==== Side Effects
  #
  # * Cria uma nova matrícula para o aluno na turma.
  # * Redireciona para a página de gerenciamento.
  #
  def cadastrar_aluno_disciplina
    redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @turma = Turma.find(params[:turma_id])
    @aluno = User.find(params[:aluno_id])

    if @turma.matriculas.exists?(user_id: @aluno.id)
      redirect_to gerenciar_disciplinas_path, alert: 'Este aluno já está matriculado nesta turma.'
      return
    end

    @turma.matriculas.create!(user: @aluno)

    aluno_name = @aluno.name
    disciplina_nome = @turma.disciplina.nome
    redirect_to gerenciar_disciplinas_path, notice: "Aluno #{aluno_name} matriculado na disciplina #{disciplina_nome}."
  end

  private

  def set_user_disciplinas
    # Este método pode ser usado para carregar disciplinas com base no usuário, se necessário
  end
end
