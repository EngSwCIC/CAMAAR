class ClassesController < ApplicationController
  before_action :set_turma, only: [:show, :edit, :update, :destroy]

  def index
    @classes = Classe.all
  end

  def show
  end

  def new
    @classe= Classe.new
    @disciplinas = Disciplina.all
    @docentes = User.where(type: 'Docente')
  end

  # GET /classes/1/edit
  def edit
    @disciplinas = Disciplina.all
    @docentes = User.where(type: 'Docente')
  end

  # POST /classes
  def create
    @classe = Classe.new(classe_params)

    if @classe.save
      redirect_to @classe, notice: 'Classe foi criada com sucesso.'
    else
      @disciplinas = Disciplina.all
      @docentes = User.where(type: 'Docente')
      render :new
    end
  end

  # PATCH/PUT /classes/1
  def update
    if @classe.update(classe_params)
      redirect_to @classe, notice: 'Classe foi atualizada com sucesso.'
    else
      @disciplinas = Disciplina.all
      @docentes = User.where(type: 'Docente')
      render :edit
    end
  end


  def destroy
    @classe.destroy
    redirect_to classes_url, notice: 'Classe excluída com sucesso.'
  end

  private

  def set_turma
    @classe = Classe.find(params[:id])
  end

  def turma_params
    params.require(:classe).permit(:class_code, :semestre, :horario, :disciplina_id, :docente_id)
  end
end
