class MateriaController < ApplicationController
  before_action :set_materium, only: %i[ show edit update destroy ]

  # GET /materia or /materia.json
  def index
    @materia = Materium.all
  end

  # GET /materia/1 or /materia/1.json
  def show
  end

  # GET /materia/new
  def new
    @materium = Materium.new
  end

  # GET /materia/1/edit
  def edit
  end

  # POST /materia or /materia.json
  def create
    @materium = Materium.new(materium_params)

    respond_to do |format|
      if @materium.save
        format.html { redirect_to materium_url(@materium), notice: "Materium was successfully created." }
        format.json { render :show, status: :created, location: @materium }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @materium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materia/1 or /materia/1.json
  def update
    respond_to do |format|
      if @materium.update(materium_params)
        format.html { redirect_to materium_url(@materium), notice: "Materium was successfully updated." }
        format.json { render :show, status: :ok, location: @materium }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @materium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materia/1 or /materia/1.json
  def destroy
    @materium.destroy!

    respond_to do |format|
      format.html { redirect_to materia_url, notice: "Materium was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST
  def search_in_sigaa
    sigaa_materiums = Materium.get_sigaa_classes

    for sigaa_materium in sigaa_materiums
      if Materium.find_by_codigo(sigaa_materium.code).nil?
        Materium.create(sigaa_materium)
      else
        Materium.find_by_codigo(sigaa_materium.code).update(sigaa_materium)
      end
    end

  rescue Materium::ConnectionTimeoutError
    flash[:warning] = "Erro, não foi possível concluir a operação"

    flash[:warning] = "Turmas importadas com sucesso do SIGAA"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_materium
      @materium = Materium.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def materium_params
      params.require(:materium).permit(:codigo, :semestre, :nome, :departamento, :professor_id, :aluno_id, :forms_materia)
    end
end
