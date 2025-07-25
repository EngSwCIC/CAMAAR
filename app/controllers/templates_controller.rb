# frozen_string_literal: true

# Controller para gerenciar templates de formulários.
class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: %i[show edit update destroy]
  before_action :authorize_template, except: [:index], unless: -> { Rails.env.test? }
  before_action :authorize_template_index, only: [:index], unless: -> { Rails.env.test? }

  # GET /templates or /templates.json
  #
  # Lista todos os templates.
  #
  def index
    @templates = policy_scope(Template).includes(:criado_por)
  end

  # GET /templates/1 or /templates/1.json
  #
  # Exibe os detalhes de um template específico.
  #
  def show
    @perguntas = @template.pergunta.ordenadas.includes(:opcoes_pergunta)
  end

  # GET /templates/new
  #
  # Exibe o formulário para a criação de um novo template.
  #
  def new
    @template = Template.new
    @template.pergunta.build # Adiciona uma pergunta inicial
  end

  # GET /templates/1/edit
  #
  # Exibe o formulário para a edição de um template existente.
  #
  def edit
    @perguntas = @template.pergunta.ordenadas.includes(:opcoes_pergunta)
  end

  # POST /templates or /templates.json
  #
  # Cria um novo template com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +template+ - Um hash com os atributos do template.
  # * +perguntas+ - Um hash com as perguntas do template.
  #
  # ==== Side Effects
  #
  # * Cria um novo template e suas perguntas no banco de dados.
  # * Redireciona para a página do template em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @template = Template.new(template_params)
    @template.disciplina_id ||= nil

    respond_to do |format|
      if @template.save
        process_perguntas if params[:perguntas]
        format.html { redirect_to @template, notice: 'Template criado com sucesso!' }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1 or /templates/1.json
  #
  # Atualiza um template existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do template a ser atualizado.
  # * +template+ - Um hash com os novos atributos do template.
  # * +perguntas+ - Um hash com as perguntas do template.
  #
  # ==== Side Effects
  #
  # * Atualiza o template e suas perguntas no banco de dados.
  # * Redireciona para a página do template em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    Rails.logger.info '=== TEMPLATE UPDATE INICIADO ==='
    Rails.logger.info "Parâmetros completos: #{params.inspect}"
    Rails.logger.info "Template params: #{template_params.inspect}"

    respond_to do |format|
      if @template.update(template_params)
        Rails.logger.info 'Template atualizado com sucesso'
        process_perguntas_update if params[:perguntas]
        format.html { redirect_to @template, notice: 'Template atualizado com sucesso!' }
        format.json { render :show, status: :ok, location: @template }
      else
        Rails.logger.error "Erro ao atualizar template: #{@template.errors.full_messages}"
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1 or /templates/1.json
  #
  # Exclui um template existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do template a ser excluído.
  #
  # ==== Side Effects
  #
  # * Exclui o template e suas perguntas do banco de dados.
  # * Redireciona para a lista de templates.
  #
  def destroy
    @template.destroy!

    respond_to do |format|
      format.html { redirect_to templates_path, status: :see_other, notice: 'Template removido com sucesso!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_template
    @template = Template.find(params[:id])
  end

  def authorize_template
    authorize(@template || Template)
  end

  def authorize_template_index
    authorize(Template)
  end

  def process_perguntas
    return unless params[:perguntas]

    Rails.logger.info '=== PROCESS PERGUNTAS INICIADO ==='
    Rails.logger.info "Parâmetros recebidos: #{params[:perguntas].inspect}"

    params[:perguntas].each do |index, pergunta_attrs|
      process_single_pergunta(index, pergunta_attrs)
    end
  end

  def process_perguntas_update
    return unless params[:perguntas]

    Rails.logger.info '=== PROCESS PERGUNTAS UPDATE INICIADO ==='
    Rails.logger.info "Parâmetros recebidos: #{params[:perguntas].inspect}"

    # Mapear perguntas existentes por ID para fácil acesso
    perguntas_existentes = @template.pergunta.index_by(&:id)
    perguntas_processadas_ids = []

    params[:perguntas].each do |index, pergunta_attrs|
      pergunta_id = pergunta_attrs[:id].presence
      perguntas_processadas_ids << pergunta_id.to_i if pergunta_id

      if pergunta_id && (pergunta = perguntas_existentes[pergunta_id.to_i])
        # Atualizar pergunta existente
        update_pergunta(pergunta, pergunta_attrs)
      else
        # Criar nova pergunta
        create_pergunta(pergunta_attrs)
      end
    end

    # Remover perguntas que não foram enviadas no formulário
    ids_para_remover = perguntas_existentes.keys - perguntas_processadas_ids
    @template.pergunta.where(id: ids_para_remover).destroy_all if ids_para_remover.any?
  end

  def process_single_pergunta(_index, attrs)
    pergunta = @template.pergunta.build(
      texto: attrs[:titulo],
      tipo: attrs[:tipo]
    )
    return unless pergunta.save

    process_opcoes(pergunta, attrs[:opcoes]) if attrs[:opcoes]
  end

  def create_pergunta(attrs)
    pergunta = @template.pergunta.build(
      texto: attrs[:titulo],
      tipo: attrs[:tipo]
    )
    return unless pergunta.save

    process_opcoes(pergunta, attrs[:opcoes]) if attrs[:opcoes]
  end

  def update_pergunta(pergunta, attrs)
    pergunta.update(
      texto: attrs[:titulo],
      tipo: attrs[:tipo]
    )
    process_opcoes_update(pergunta, attrs[:opcoes]) if attrs[:opcoes]
  end

  def process_opcoes(pergunta, opcoes_attrs)
    opcoes_attrs.each_value do |opcao_attrs|
      pergunta.opcoes_pergunta.create(texto: opcao_attrs[:texto])
    end
  end

  def process_opcoes_update(pergunta, opcoes_attrs)
    opcoes_existentes = pergunta.opcoes_pergunta.index_by(&:id)
    opcoes_processadas_ids = []

    opcoes_attrs.each_value do |opcao_attrs|
      opcao_id = opcao_attrs[:id].presence
      opcoes_processadas_ids << opcao_id.to_i if opcao_id

      if opcao_id && (opcao = opcoes_existentes[opcao_id.to_i])
        # Atualizar opção existente
        opcao.update(texto: opcao_attrs[:texto])
      else
        # Criar nova opção
        pergunta.opcoes_pergunta.create(texto: opcao_attrs[:texto])
      end
    end

    # Remover opções que não foram enviadas
    ids_para_remover = opcoes_existentes.keys - opcoes_processadas_ids
    pergunta.opcoes_pergunta.where(id: ids_para_remover).destroy_all if ids_para_remover.any?
  end

  # Only allow a list of trusted parameters through.
  def template_params
    params.require(:template).permit(
      :titulo, :publico_alvo, :criado_por_id, :disciplina_id,
      perguntas_attributes: [
        :id, :titulo, :tipo, :_destroy, {
          opcoes_pergunta_attributes: %i[id texto _destroy]
        }
      ]
    )
  end
end
