# Controlador para gerenciar as ações relacionadas aos Formulários
class FormulariosController < ApplicationController
  before_action :set_formulario, only: %i[ show edit update destroy ]

  ##
  # GET /formularios or /formularios.json
  # Exibe a lista de todos os formulários
  def index
    @formularios = Formulario.joins(turma: [:professor, :materia], template: [])
    .select('formularios.*, turmas.classCode as turma_classCode, turmas.semestre as turma_semestre, users.nome as professor_name, materias.nome as materia_nome')
  end

  ##
  # GET /formularios/1 or /formularios/1.json
  # Exibe um formulário específico
  # +param+ [Integer] id - O ID do formulário a ser exibido, obtido dos parâmetros
  def show
  end

  ##
  # GET /formularios/new
  # Exibe o formulário para criar um novo formulário
  def new
    @formulario = Formulario.new
  end

  ##
  # GET /formularios/1/edit
  # Exibe o formulário para editar um formulário existente
  #
  # +param+ [Integer] id - O ID do formulário a ser editado, obtido dos parâmetros
  def edit
  end

  ##
  # POST /formularios or /formularios.json
  # Cria um novo formulário
  #
  # +param+ [Hash] formulario_params - Os parâmetros do formulário a ser criado, obtido dos parâmetros permitidos
  # +effect_side+ Cria um novo registro de formulário no banco de dados. Redireciona para a página show se bem-sucedido, ou renderiza a página new se houver erros
  def create
    @formulario = Formulario.new(formulario_params)

    respond_to do |format|
      if @formulario.save
        format.html { redirect_to formulario_url(@formulario), notice: "Formulario was successfully created." }
        format.json { render :show, status: :created, location: @formulario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  ##
  # PATCH/PUT /formularios/1 or /formularios/1.json
  # Atualiza um formulário existente
  #
  # +param+ [Hash] formulario_params - Os parâmetros do formulário a ser atualizado, obtido dos parâmetros permitidos
  # +param+ [Integer] id - O ID do formulário a ser atualizado, obtido dos parâmetros
  # +effect_side+ Atualiza um registro de formulário no banco de dados. Redireciona para a página show se bem-sucedido, ou renderiza a página edit se houver erros
  def update
    respond_to do |format|
      if @formulario.update(formulario_params)
        format.html { redirect_to formulario_url(@formulario), notice: "Formulario was successfully updated." }
        format.json { render :show, status: :ok, location: @formulario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  ##
  # DELETE /formularios/1 or /formularios/1.json
  # Exclui um formulário existente
  #
  # +param+ [Integer] id - O ID do formulário a ser excluído, obtido dos parâmetros
  # +effect_side+ Remove um registro de formulário do banco de dados. Redireciona para a página index após exclusão
  def destroy
    @formulario.destroy!

    respond_to do |format|
      format.html { redirect_to formularios_url, notice: "Formulario was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formulario
      @formulario = Formulario.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def formulario_params
      params.require(:formulario).permit(:id_turma, :id_template)
    end
end
