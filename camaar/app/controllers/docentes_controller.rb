class DocentesController < ApplicationController
  before_action :set_docente, only: [:show, :edit, :update, :destroy]

  def index
    @docente = Docente.all
  end

  def show
  end

  def new
    @docente = Docente.new
  end

  def edit
  end

  def create
    @docente = Docente.new(docente_params)

    if @docente.save
      redirect_to @docente, notice: 'Docente criado com sucesso.'
    else
      render :new
    end
  end

  def update
    if @docente.update(docente_params)
      redirect_to @docente, notice: 'Docente atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @docente.destroy
    redirect_to docentes_url, notice: 'Docente excluído com sucesso.'
  end

  private

  def set_docente
    @docente = Docente.find(params[:id])
  end

  def docente_params
    params.require(:docente).permit(:nome, :senha)
  end
end
