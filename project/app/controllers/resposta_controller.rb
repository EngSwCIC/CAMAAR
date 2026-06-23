class RespostaController < ApplicationController
  before_action :set_respostum, only: %i[ show edit update destroy ]

  # GET /resposta or /resposta.json
  def index
    @resposta = Respostum.all
  end

  # GET /resposta/1 or /resposta/1.json
  def show
  end

  # GET /resposta/new
  def new
    @respostum = Respostum.new
  end

  # GET /resposta/1/edit
  def edit
  end

  # POST /resposta or /resposta.json
  def create
    # Caminho Triste: Valida se o campo de nota foi deixado em branco pelo robô/usuário
    if params.dig(:respostum, :valor_numerico).blank?
      redirect_to formulario_path(params[:respostum][:formulario_id]), alert: "Por favor, preencha todas as questões obrigatórias"
      return
    end

    # Caminho Feliz: Cria a submissão vinculando o usuário e o formulário (idêntico ao banco)
    @submissao = Submissao.find_or_create_by!(
      user_id: current_user.id,
      formulario_id: params[:respostum][:formulario_id]
    )

    # Cria a resposta vinculando à questão e à submissão recém-criada
    @respostum = Respostum.new(
      valor_numerico: params[:respostum][:valor_numerico],
      questao_id: params[:respostum][:questao_id],
      submissao_id: @submissao.id
    )

    if @respostum.save
      redirect_to formularios_path, notice: "Avaliação submetida com sucesso"
    else
      redirect_to formulario_path(params[:respostum][:formulario_id]), alert: "Por favor, preencha todas as questões obrigatórias"
    end
  end

  # PATCH/PUT /resposta/1 or /resposta/1.json
  def update
    respond_to do |format|
      if @respostum.update(respostum_params)
        format.html { redirect_to @respostum, notice: "Respostum was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @respostum }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @respostum.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /resposta/1 or /resposta/1.json
  def destroy
    @respostum.destroy!

    respond_to do |format|
      format.html { redirect_to resposta_path, notice: "Respostum was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_respostum
      @respostum = Respostum.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def respostum_params
      params.expect(respostum: [ :valor_texto, :valor_numerico, :submissao_id, :questao_id ])
    end
end
