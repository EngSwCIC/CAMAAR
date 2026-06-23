class QuestaosController < ApplicationController
  before_action :set_questao, only: %i[ show edit update destroy ]

  # GET /questaos or /questaos.json
  def index
    @questaos = Questao.all
  end

  # GET /questaos/1 or /questaos/1.json
  def show
  end

  # GET /questaos/new
  def new
    @questao = Questao.new
  end

  # GET /questaos/1/edit
  def edit
  end

  # POST /questaos or /questaos.json
  def create
    @questao = Questao.new(questao_params)

    respond_to do |format|
      if @questao.save
        format.html { redirect_to @questao, notice: "Questao was successfully created." }
        format.json { render :show, status: :created, location: @questao }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @questao.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /questaos/1 or /questaos/1.json
  def update
    respond_to do |format|
      if @questao.update(questao_params)
        format.html { redirect_to @questao, notice: "Questao was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @questao }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @questao.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /questaos/1 or /questaos/1.json
  def destroy
    @questao.destroy!

    respond_to do |format|
      format.html { redirect_to questaos_path, notice: "Questao was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_questao
      @questao = Questao.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def questao_params
      params.expect(questao: [ :enunciado, :tipo, :template_id, :formulario_id ])
    end
end
