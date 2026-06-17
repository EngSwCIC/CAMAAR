class DocentesController < ApplicationController
  before_action :set_docente, only: %i[ show edit update destroy ]

  # GET /docentes or /docentes.json
  def index
    @docentes = Docente.all
  end

  # GET /docentes/1 or /docentes/1.json
  def show
  end

  # GET /docentes/new
  def new
    @docente = Docente.new
  end

  # GET /docentes/1/edit
  def edit
  end

  # POST /docentes or /docentes.json
  def create
    @docente = Docente.new(docente_params)

    respond_to do |format|
      if @docente.save
        format.html { redirect_to @docente, notice: "Docente was successfully created." }
        format.json { render :show, status: :created, location: @docente }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @docente.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /docentes/1 or /docentes/1.json
  def update
    respond_to do |format|
      if @docente.update(docente_params)
        format.html { redirect_to @docente, notice: "Docente was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @docente }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @docente.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /docentes/1 or /docentes/1.json
  def destroy
    @docente.destroy!

    respond_to do |format|
      format.html { redirect_to docentes_path, notice: "Docente was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_docente
      @docente = Docente.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def docente_params
      params.expect(docente: [ :matricula, :email, :nome, :formacao ])
    end
end
