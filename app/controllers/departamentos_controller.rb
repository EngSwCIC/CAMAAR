class DepartamentosController < ApplicationController
  before_action :set_departamento, only: %i[ show edit update destroy ]

  # GET /departamentos or /departamentos.json
  def index
    @departamentos = Departamento.all
  end

  # GET /departamentos/1 or /departamentos/1.json
  def show
  end

  # GET /departamentos/new
  def new
    @departamento = Departamento.new
  end

  # GET /departamentos/1/edit
  def edit
  end

  # POST /departamentos or /departamentos.json
  def create
    @departamento = Departamento.new(departamento_params)

    respond_to do |format|
      if @departamento.save
        format.html { redirect_to @departamento, notice: "Departamento was successfully created." }
        format.json { render :show, status: :created, location: @departamento }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @departamento.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /departamentos/1 or /departamentos/1.json
  def update
    respond_to do |format|
      if @departamento.update(departamento_params)
        format.html { redirect_to @departamento, notice: "Departamento was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @departamento }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @departamento.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /departamentos/1 or /departamentos/1.json
  def destroy
    @departamento.destroy!

    respond_to do |format|
      format.html { redirect_to departamentos_path, notice: "Departamento was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_departamento
      @departamento = Departamento.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def departamento_params
      params.expect(departamento: [ :codigo, :nome ])
    end
end
