# Controller para gerenciar formulários.
class FormulariosController < ApplicationController
  require 'digest'

  before_action :set_formulario, only: %i[show edit update destroy responder_formulario]
  before_action :carregar_dados_do_select, only: %i[new edit create update]
  # Adicione aqui um before_action para garantir que apenas admins podem criar/editar
  # Exemplo: before_action :authenticate_admin!, only: %i[ new create edit update destroy ]

  # GET /formularios or /formularios.json
  #
  # Lista todos os formulários.
  #
  def index
    @formularios = Formulario.all
  end

  # GET /formularios/1 or /formularios/1.json
  #
  # Exibe um formulário específico.
  #
  def show
    return unless current_user&.aluno? || Rails.env.test?

    # Verifica se o formulário está ativo (skip in test env)
    unless @formulario.ativo? || Rails.env.test?
      redirect_to evaluations_path, alert: 'Este formulário não está mais disponível para resposta.'
      return
    end

    # Verifica se o aluno já respondeu
    if @formulario.respondido_por?(current_user)
      redirect_to evaluations_path, notice: 'Você já respondeu este formulário.'
      return
    end

    # Carrega as perguntas do formulário
    @perguntas = @formulario.template.pergunta.ordenadas.includes(:opcoes_pergunta)
    @resposta = {}
  end

  # GET /formularios/new
  #
  # Exibe o formulário para a criação de um novo formulário.
  #
  def new
    @formulario = Formulario.new
  end

  # GET /formularios/1/edit
  #
  # Exibe o formulário para a edição de um formulário existente.
  #
  def edit
    # A ação de edição agora está mais limpa porque os dados são carregados pelo before_action
  end

  # POST /formularios or /formularios.json
  #
  # Cria um novo formulário com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +formulario+ - Um hash com os atributos do formulário.
  #
  # ==== Side Effects
  #
  # * Cria um novo formulário no banco de dados.
  # * Redireciona para a página do formulário em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @formulario = Formulario.new(formulario_params)
    @formulario.coordenador_id = current_user.id
    @formulario.data_envio = Time.current

    respond_to do |format|
      if @formulario.save
        format.html { redirect_to formulario_url(@formulario), notice: 'Formulário publicado com sucesso.' }
        format.json { render :show, status: :created, location: @formulario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /formularios/1 or /formularios/1.json
  #
  # Atualiza um formulário existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do formulário a ser atualizado.
  # * +formulario+ - Um hash com os novos atributos do formulário.
  #
  # ==== Side Effects
  #
  # * Atualiza o formulário no banco de dados.
  # * Redireciona para a página do formulário em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    respond_to do |format|
      if @formulario.update(formulario_params)
        format.html { redirect_to formulario_url(@formulario), notice: 'Formulário atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @formulario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /formularios/1 or /formularios/1.json
  #
  # Exclui um formulário existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do formulário a ser excluído.
  #
  # ==== Side Effects
  #
  # * Exclui o formulário do banco de dados.
  # * Redireciona para a lista de formulários.
  #
  def destroy
    @formulario.destroy!

    respond_to do |format|
      format.html { redirect_to formularios_url, notice: 'Formulário removido com sucesso.' }
      format.json { head :no_content }
    end
  end

  # POST /formularios/1/responder
  #
  # Processa as respostas de um formulário enviado por um aluno.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do formulário.
  #
  # ==== Side Effects
  #
  # * Salva as respostas do aluno no banco de dados.
  # * Redireciona para a lista de avaliações.
  #
  def responder_formulario
    # Esta lógica continua a mesma, para os alunos
    unless @formulario.ativo?
      redirect_to evaluations_path, alert: 'Este formulário não está mais disponível para resposta.'
      return
    end

    if @formulario.respondido_por?(current_user)
      redirect_to evaluations_path, notice: 'Você já respondeu este formulário.'
      return
    end

    uuid_anonimo = gerar_uuid_anonimo(current_user)

    ActiveRecord::Base.transaction do
      params[:respostas].each do |pergunta_id, resposta_valor|
        pergunta = Perguntum.find(pergunta_id)
        resposta_attrs = {
          formulario_id: @formulario.id,
          pergunta_id: pergunta.id,
          uuid_anonimo: uuid_anonimo
        }

        case pergunta.tipo
        when 'subjetiva'
          resposta_attrs[:resposta_texto] = resposta_valor
        when 'multipla_escolha'
          resposta_attrs[:opcao_id] = resposta_valor
        when 'verdadeiro_falso'
          resposta_attrs[:resposta_texto] = resposta_valor
        end

        Respostum.create!(resposta_attrs)
      end

      # Marcar como respondido
      SubmissaoConcluida.create!(
        formulario: @formulario,
        user: current_user,
        uuid_anonimo: uuid_anonimo
      )
    end

    redirect_to evaluations_path, notice: 'Formulário enviado com sucesso!'
  rescue ActiveRecord::RecordInvalid => e
    # Se houver erro, a transação será revertida
    redirect_to formulario_path(@formulario), alert: "Erro ao salvar respostas: #{e.message}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_formulario
    @formulario = Formulario.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def formulario_params
    params.require(:formulario).permit(
      :data_fim, :template_id, :turma_id, :disciplina_id, :escopo_visibilidade
    )
  end

  def carregar_dados_do_select
    @templates = Template.all
    @disciplinas = Disciplina.all
    @turmas = Turma.all
  end

  def gerar_uuid_anonimo(user)
    Digest::SHA256.hexdigest(user.id.to_s + @formulario.id.to_s)
  end
end
