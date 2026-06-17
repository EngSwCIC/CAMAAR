class DisciplinasController < ApplicationController
  before_action :set_disciplina, only: %i[ show edit update destroy ]

  # GET /disciplinas or /disciplinas.json
  def index
    @disciplinas = Disciplina.all
  end

  # GET /disciplinas/1 or /disciplinas/1.json
  def show
  end

  # GET /disciplinas/new
  def new
    @disciplina = Disciplina.new
  end

  # GET /disciplinas/1/edit
  def edit
  end

  # POST /disciplinas or /disciplinas.json
  def create
    @disciplina = Disciplina.new(disciplina_params)

    respond_to do |format|
      if @disciplina.save
        format.html { redirect_to @disciplina, notice: "Disciplina was successfully created." }
        format.json { render :show, status: :created, location: @disciplina }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @disciplina.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /disciplinas/1 or /disciplinas/1.json
  def update
    respond_to do |format|
      if @disciplina.update(disciplina_params)
        format.html { redirect_to @disciplina, notice: "Disciplina was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @disciplina }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @disciplina.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /disciplinas/1 or /disciplinas/1.json
  def destroy
    @disciplina.destroy!

    respond_to do |format|
      format.html { redirect_to disciplinas_path, notice: "Disciplina was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disciplina
      @disciplina = Disciplina.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def disciplina_params
      params.expect(disciplina: [ :codigo, :nome, :departamento_id ])
    end
end
