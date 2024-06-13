class QuestoesController < ApplicationController
  before_action :set_questao, only: %i[ show edit update destroy ]

  # GET /questoes or /questoes.json
  def index
    @questoes = Questao.all
  end

  # GET /questoes/1 or /questoes/1.json
  def show
  end

  # GET /questoes/new
  def new
    @questao = Questao.new
  end

  # GET /questoes/1/edit
  def edit
  end

  # POST /questoes or /questoes.json
  def create
    @questao = Questao.new(questao_params)

    respond_to do |format|
      if @questao.save
        format.html { redirect_to questao_url(@questao), notice: "Questao was successfully created." }
        format.json { render :show, status: :created, location: @questao }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @questao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questoes/1 or /questoes/1.json
  def update
    respond_to do |format|
      if @questao.update(questao_params)
        format.html { redirect_to questao_url(@questao), notice: "Questao was successfully updated." }
        format.json { render :show, status: :ok, location: @questao }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @questao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questoes/1 or /questoes/1.json
  def destroy
    @questao.destroy!

    respond_to do |format|
      format.html { redirect_to questoes_url, notice: "Questao was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_questao
      @questao = Questao.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def questao_params
      params.require(:questao).permit(:tipo_questao)
    end
end
