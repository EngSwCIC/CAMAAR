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

  def import
    if request.post?
      file = params[:file]

      if file
        data = JSON.parse(file.read)
        data.each do |course_data|
          disciplina = Disciplina.create!(
            codigo: course_data['code'],
            nome: course_data['name']
          )

          class_data = course_data['class']
          Turma.create!(
            disciplina_id: disciplina.id,
            class_code: class_data['classCode'],
            semestre: class_data['semester'],
            horario: class_data['time'],
            codigo: disciplina.codigo
          )
        end

        render json: { message: 'Courses imported successfully' }, status: :ok
      else
        render json: { error: 'No file provided' }, status: :unprocessable_entity
      end
    else
      render :import
    end
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
