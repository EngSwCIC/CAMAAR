# frozen_string_literal: true

# Adicione um comentário de documentação para a classe TemplatesController.
class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: %i[show edit update destroy]
  before_action :authorize_template, except: [:index]
  before_action :authorize_template_index, only: [:index]

  # GET /templates or /templates.json
  def index
    @templates = policy_scope(Template).includes(:criado_por)
  end

  # GET /templates/1 or /templates/1.json
  def show
    @perguntas = @template.pergunta.ordenadas.includes(:opcoes_pergunta)
  end

  # GET /templates/new
  def new
    @template = Template.new
    @template.pergunta.build # Adiciona uma pergunta inicial
  end

  # GET /templates/1/edit
  def edit
    @perguntas = @template.pergunta.ordenadas.includes(:opcoes_pergunta)
  end

  # POST /templates or /templates.json
  def create
    @template = Template.new(template_params)
    @template.criado_por = current_user

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
  def update
    Rails.logger.info "=== TEMPLATE UPDATE INICIADO ==="
    Rails.logger.info "Parâmetros completos: #{params.inspect}"
    Rails.logger.info "Template params: #{template_params.inspect}"
    
    respond_to do |format|
      if @template.update(template_params)
        Rails.logger.info "Template atualizado com sucesso"
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
    @template = Template.find(params.expect(:id))
  end

  def authorize_template
    authorize(@template || Template)
  end

  def authorize_template_index
    authorize(Template)
  end

  def process_perguntas
    return unless params[:perguntas]
    
    Rails.logger.info "=== PROCESS PERGUNTAS INICIADO ==="
    Rails.logger.info "Parâmetros recebidos: #{params[:perguntas].inspect}"

    params[:perguntas].each do |index, pergunta_attrs|
      Rails.logger.info "Processando pergunta #{index}: #{pergunta_attrs.inspect}"
      
      next if pergunta_attrs[:texto].blank?

      pergunta = @template.pergunta.create!(
        texto: pergunta_attrs[:texto],
        tipo: pergunta_attrs[:tipo],
        obrigatoria: pergunta_attrs[:obrigatoria] == '1' || pergunta_attrs[:obrigatoria] == 'on'
      )
      
      Rails.logger.info "Pergunta criada: ID=#{pergunta.id}, Texto=#{pergunta.texto}"

      # Criar opções se for múltipla escolha ou verdadeiro/falso
      if pergunta_attrs[:opcoes] && pergunta.multipla_escolha_ou_verdadeiro_falso?
        pergunta_attrs[:opcoes].each do |_, opcao_texto|
          next if opcao_texto.blank?
          opcao = pergunta.opcoes_pergunta.create!(texto: opcao_texto)
          Rails.logger.info "Opção criada: ID=#{opcao.id}, Texto=#{opcao.texto}"
        end
      end
    end
    
    Rails.logger.info "=== PROCESS PERGUNTAS FINALIZADO ==="
  end

  def process_perguntas_update
    return unless params[:perguntas]

    # Coletar IDs das perguntas que foram enviadas
    pergunta_ids_enviadas = []
    
    params[:perguntas].each do |index, pergunta_attrs|
      next if pergunta_attrs[:texto].blank?

      if pergunta_attrs[:id].present?
        # Pergunta existente - atualizar
        pergunta = @template.pergunta.find(pergunta_attrs[:id])
        pergunta.update!(
          texto: pergunta_attrs[:texto],
          tipo: pergunta_attrs[:tipo],
          obrigatoria: pergunta_attrs[:obrigatoria] == '1' || pergunta_attrs[:obrigatoria] == 'on'
        )
        pergunta_ids_enviadas << pergunta.id
        
        # Remover opções existentes e recriar
        pergunta.opcoes_pergunta.destroy_all
      else
        # Nova pergunta - criar
        pergunta = @template.pergunta.create!(
          texto: pergunta_attrs[:texto],
          tipo: pergunta_attrs[:tipo],
          obrigatoria: pergunta_attrs[:obrigatoria] == '1' || pergunta_attrs[:obrigatoria] == 'on'
        )
        pergunta_ids_enviadas << pergunta.id
      end

      # Criar opções se for múltipla escolha ou verdadeiro/falso
      if pergunta_attrs[:opcoes] && pergunta.multipla_escolha_ou_verdadeiro_falso?
        pergunta_attrs[:opcoes].each do |_, opcao_texto|
          next if opcao_texto.blank?
          pergunta.opcoes_pergunta.create!(texto: opcao_texto)
        end
      end
    end
    
    # Remover perguntas que não foram enviadas (foram deletadas no frontend)
    @template.pergunta.where.not(id: pergunta_ids_enviadas).destroy_all
  end

  # Only allow a list of trusted parameters through.
  def template_params
    permitted_params = params.expect(template: %i[titulo descricao publico_alvo disciplina_id])
    
    # Permitir parâmetros aninhados das perguntas
    if params[:perguntas]
      permitted_params = params.permit(:template => %i[titulo descricao publico_alvo disciplina_id],
                                      :perguntas => {})
    end
    
    permitted_params[:template] || permitted_params
  end
end
