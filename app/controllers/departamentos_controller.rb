class DepartamentosController < ApplicationController
  before_action :set_departamento, only: %i[ show edit update destroy ]

  # GET /departamentos or /departamentos.json
  def index
    @departamentos = Departamento.all
  end

  # GET /departamentos/1 or /departamentos/1.json
  def show
    @departamento = Departamento.find(params[:id])
  end

  # GET /departamentos/new
  def new
    @departamento = Departamento.new
  end

  # GET /departamentos/1/edit
  def edit
    @departamento = Departamento.find(params[:id])
  end

  # POST /departamentos or /departamentos.json
  def create
    @departamento = Departamento.new(departamento_params)

    respond_to do |format|
      if @departamento.save
        format.html { redirect_to departamento_url(@departamento), notice: "Departamento was successfully created." }
        format.json { render :show, status: :created, location: @departamento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @departamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departamentos/1 or /departamentos/1.json
  def update
    respond_to do |format|
      if @departamento.update(departamento_params)
        format.html { redirect_to departamento_url(@departamento), notice: "Departamento was successfully updated." }
        format.json { render :show, status: :ok, location: @departamento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @departamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departamentos/1 or /departamentos/1.json
  def destroy
    @departamento.destroy

    respond_to do |format|
      format.html { redirect_to departamentos_url, notice: "Departamento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_departamento
      @departamento = Departamento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def departamento_params
      params.require(:departamento).permit(:nome)
    end
end
