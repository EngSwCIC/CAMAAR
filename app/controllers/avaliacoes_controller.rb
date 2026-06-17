class AvaliacoesController < ApplicationController
  before_action :require_user
  before_action :set_formulario, only: [ :new, :create ]

  def index
    now = Time.current
    if current_user.perfil == "administrador"
      @pesquisas_pendentes = Formulario.where(status: "aberto")
    elsif current_user.perfil == "docente"
      answered_ids = current_user.respostas.pluck(:formulario_id)
      @pesquisas_pendentes = Formulario.where(
        turma_id: Turma.where(docente_id: current_user.id).pluck(:id),
        status: "aberto",
        publico_alvo: [ "docente", "docentes" ]
      ).where("data_inicio <= ? AND data_limite >= ?", now, now)

      @pesquisas_respondidas = Formulario.where(id: answered_ids)
      @pesquisas_pendentes = @pesquisas_pendentes.where.not(id: answered_ids) if answered_ids.any?
    else
      # Discente
      turma_ids = current_user.matriculas.pluck(:turma_id)
      answered_ids = current_user.respostas.pluck(:formulario_id)
      @pesquisas_pendentes = Formulario.where(
        turma_id: turma_ids,
        status: "aberto",
        publico_alvo: [ "discente", "discentes" ]
      ).where("data_inicio <= ? AND data_limite >= ?", now, now)

      @pesquisas_respondidas = Formulario.where(id: answered_ids)
      @pesquisas_pendentes = @pesquisas_pendentes.where.not(id: answered_ids) if answered_ids.any?
    end
  end

  def new
    # Already set by before_action
  end

  def create
    # 1. Check double submission first
    if Resposta.exists?(formulario: @formulario, usuario: current_user)
      flash[:alert] = "Você já respondeu a este formulário"
      redirect_to avaliacoes_path and return
    end

    # 2. Validate mandatory fields
    required_missing = false
    @formulario.template.perguntas.each_with_index do |pergunta, idx|
      next unless pergunta.obrigatoria?

      resp_param = params[:respostas]&.[](idx.to_s)
      if resp_param.nil?
        required_missing = true
        break
      end

      if pergunta.tipo == "likert"
        if resp_param[:nota].blank?
          required_missing = true
          break
        end
      else
        if resp_param[:texto].blank?
          required_missing = true
          break
        end
      end
    end

    if required_missing
      flash[:alert] = "Preencha todos os campos obrigatórios"
      redirect_to responder_avaliacao_path(@formulario) and return
    end

    ActiveRecord::Base.transaction do
      # Create parent Resposta
      @resposta = Resposta.create!(
        formulario: @formulario,
        usuario: current_user,
        enviado_em: Time.current
      )

      # Create RespostaItems (discard if blank and optional)
      @formulario.template.perguntas.each_with_index do |pergunta, idx|
        resp_param = params[:respostas]&.[](idx.to_s)
        next unless resp_param

        if pergunta.tipo == "likert"
          next if resp_param[:nota].blank?
        else
          next if resp_param[:texto].blank?
        end

        RespostaItem.create!(
          resposta: @resposta,
          questao_template: pergunta,
          valor_numerico: resp_param[:nota],
          valor_texto: resp_param[:texto],
          valor_opcao: resp_param[:nota] ? "Nota #{resp_param[:nota]}" : nil
        )
      end
    end

    flash[:notice] = "Sua avaliação foi enviada com sucesso! Muito obrigado por contribuir."
    redirect_to avaliacoes_path
  rescue => e
    flash[:alert] = "Erro ao enviar avaliação: #{e.message}"
    redirect_to responder_avaliacao_path(@formulario)
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
end
