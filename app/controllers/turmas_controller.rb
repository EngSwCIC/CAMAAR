class TurmasController < ApplicationController
  before_action :set_turma, only: %i[ show edit update destroy ]

  # GET /turmas or /turmas.json
  def index
    @turmas = Turma.all
  end

  # GET /turmas/1 or /turmas/1.json
  def show
  end

  # GET /turmas/new
  def new
    @turma = Turma.new
  end

  # GET /turmas/1/edit
  def edit
  end

  # POST /turmas or /turmas.json
  def create
    @turma = Turma.new(turma_params)

    respond_to do |format|
      if @turma.save
        format.html { redirect_to @turma, notice: "Turma was successfully created." }
        format.json { render :show, status: :created, location: @turma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /turmas/1 or /turmas/1.json
  def update
    respond_to do |format|
      if @turma.update(turma_params)
        format.html { redirect_to @turma, notice: "Turma was successfully updated." }
        format.json { render :show, status: :ok, location: @turma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turmas/1 or /turmas/1.json
  def destroy
    @turma.destroy!

    respond_to do |format|
      format.html { redirect_to turmas_path, status: :see_other, notice: "Turma was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_turma
      @turma = Turma.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def turma_params
      params.expect(turma: [ :disciplina_id, :professor_id, :semestre ])
    end
end
