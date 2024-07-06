# Controlador para gerenciar as ações relacionadas às Respostas
class RespostasController < ApplicationController
  before_action :set_resposta, only: %i[ show edit update destroy ]

  ##
  # GET /respostas or /respostas.json
  # Exibe a lista de todas as respostas
  def index
    @respostas = Resposta.all
  end

  ##
  # GET /respostas/1 or /respostas/1.json
  # Exibe uma resposta específica
  #
  # +param+ [Integer] id - O ID da resposta a ser exibida, obtido dos parâmetros
  def show
  end

  ##
  # GET /respostas/new
  # Exibe o formulário para criar uma nova resposta
  def new
    @resposta = Resposta.new
  end

  ##
  # GET /respostas/1/edit
  # Exibe o formulário para editar uma resposta existente
  #
  # +param+ [Integer] id - O ID da resposta a ser editada, obtido dos parâmetros
  def edit
  end

  ##
  # POST /respostas or /respostas.json
  # Cria uma nova resposta
  #
  # +param+ [Hash] resposta_params - Os parâmetros da resposta a ser criada, obtido dos parâmetros permitidos
  # +effect_side+ Cria um novo registro de resposta no banco de dados. Redireciona para a página show se bem-sucedido, ou renderiza a página new se houver erros
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

  ##
  # PATCH/PUT /respostas/1 or /respostas/1.json
  # Atualiza uma resposta existente
  #
  # +param+ [Hash] resposta_params - Os parâmetros da resposta a ser atualizada, obtido dos parâmetros permitidos
  # +param+ [Integer] id - O ID da resposta a ser atualizada, obtido dos parâmetros
  # +effect_side+ Atualiza um registro de resposta no banco de dados. Redireciona para a página show se bem-sucedido, ou renderiza a página edit se houver erros
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

  ##
  # DELETE /respostas/1 or /respostas/1.json
  # Exclui uma resposta existente
  #
  # +param+ [Integer] id - O ID da resposta a ser excluída, obtido dos parâmetros
  # +effect_side+ Remove um registro de resposta do banco de dados. Redireciona para a página index após exclusão
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
