class RespostasController < ApplicationController
  before_action :set_resposta, only: %i[ show edit update destroy ]

  # GET /respostas or /respostas.json
  def index
    @respostas = Resposta.all
  end

  # GET /respostas/1 or /respostas/1.json
  def show
  end

  # GET /respostas/new
  def new
    @resposta = Resposta.new
  end

  # GET /respostas/1/edit
  def edit
  end

  # POST /respostas or /respostas.json
  def create
    @resposta = Resposta.new(resposta_params)

    respond_to do |format|
      if @resposta.save
        format.html { redirect_to resposta_url(@resposta), notice: "Resposta was successfully created." }
        format.json { render :show, status: :created, location: @resposta }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resposta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /respostas/1 or /respostas/1.json
  def update
    respond_to do |format|
      if @resposta.update(resposta_params)
        format.html { redirect_to resposta_url(@resposta), notice: "Resposta was successfully updated." }
        format.json { render :show, status: :ok, location: @resposta }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @resposta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /respostas/1 or /respostas/1.json
  def destroy
    @resposta.destroy!

    respond_to do |format|
      format.html { redirect_to respostas_url, notice: "Resposta was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resposta
      @resposta = Resposta.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resposta_params
      params.require(:resposta).permit(:id_questao, :id_formulario, :usuario, :resposta, :numero)
    end
end
