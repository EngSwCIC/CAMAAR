# app/controllers/disciplinas_controller.rb
class DisciplinasController < ApplicationController
  before_action :set_disciplina, only: [:show, :edit, :update, :destroy]

  # GET /disciplinas
  def index
    @disciplinas = Disciplina.all
  end

  # GET /disciplinas/1
  def show
  end

  # GET /disciplinas/new
  def new
    @disciplina = Disciplina.new
  end

  # GET /disciplinas/1/edit
  def edit
  end

  # POST /disciplinas
  def create
    @disciplina = Disciplina.new(disciplina_params)

    if @disciplina.save
      redirect_to @disciplina, notice: 'Disciplina foi criada com sucesso.'
    else
      render :new
    end
  end

  # PATCH/PUT /disciplinas/1
  def update
    if @disciplina.update(disciplina_params)
      redirect_to @disciplina, notice: 'Disciplina foi atualizada com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /disciplinas/1
  def destroy
    @disciplina.destroy
    redirect_to disciplinas_url, notice: 'Disciplina foi excluída com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disciplina
      @disciplina = Disciplina.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def disciplina_params
      params.require(:disciplina).permit(:codigo, :nome)
    end
end
