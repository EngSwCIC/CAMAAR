# frozen_string_literal: true

# Controller responsável por gerenciar avaliações para usuários
class EvaluationsController < ApplicationController
  before_action :authenticate_user!

  # GET /evaluations
  #
  # Lista os formulários de avaliação disponíveis para o usuário atual.
  #
  # ==== Returns
  #
  # * +@formularios_disponiveis+ - Lista de formulários que o usuário pode responder.
  # * +@formularios_respondidos+ - Lista de formulários que o usuário já respondeu.
  #
  def index
    @formularios = if current_user.admin?
                     # Administradores veem todos os formulários ativos (sem filtro de período)
                     Formulario.where(ativo: true)
                   elsif current_user.coordenador?
                     # Coordenadores veem formulários que eles criaram ou que são da sua área
                     Formulario.where(ativo: true, coordenador: current_user)
                   else
                     # Usuários normais veem apenas formulários que podem responder
                     Formulario.ativos.no_periodo.select do |formulario|
                       formulario.can_be_seen_by?(current_user)
                     end
                   end

    # Separar em formulários disponíveis e já respondidos
    if current_user.admin? || current_user.coordenador?
      # Para admins e coordenadores, todos são "disponíveis" (para visualização/gestão)
      @formularios_disponiveis = @formularios
      @formularios_respondidos = []
    else
      # Para outros usuários, separar entre disponíveis e respondidos
      @formularios_disponiveis = @formularios.reject { |f| f.already_answered_by?(current_user) }
      @formularios_respondidos = @formularios.select { |f| f.already_answered_by?(current_user) }
    end
  end

  # GET /evaluations/:id
  # POST /evaluations/:id
  #
  # Exibe um formulário para o usuário responder ou processa as respostas enviadas.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do formulário.
  #
  # ==== Side Effects
  #
  # * Se a requisição for POST, salva as respostas do usuário no banco de dados.
  # * Redireciona para a lista de avaliações se o usuário não tiver permissão ou já tiver respondido.
  #
  def show
    @formulario = Formulario.find(params[:id])

    # Verificar se o usuário pode ver este formulário
    unless @formulario.can_be_seen_by?(current_user)
      redirect_to evaluations_path, alert: 'Você não tem permissão para acessar este formulário.'
      return
    end

    # Verificar se já foi respondido
    if @formulario.already_answered_by?(current_user)
      redirect_to evaluations_path, notice: 'Você já respondeu este formulário.'
      return
    end

    @template = @formulario.template
    @perguntas = @template.pergunta.order(:id)

    # Se for POST, processar as respostas
    return unless request.post?

    process_respostas
  end

  # GET /evaluations/:id/results
  #
  # Mostra os resultados estatísticos de um formulário.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do formulário.
  #
  # ==== Returns
  #
  # * +@estatisticas+ - Um hash com as estatísticas das respostas.
  #
  # ==== Side Effects
  #
  # * Redireciona se o usuário não tiver permissão para ver os resultados.
  #
  def results
    @formulario = Formulario.find(params[:id])

    # Verificar se o usuário tem permissão para ver resultados
    unless current_user&.admin? || (current_user&.coordenador? && @formulario.coordenador == current_user)
      redirect_to evaluations_path, alert: 'Acesso negado. Você não tem permissão para ver estes resultados.'
      return
    end

    @template = @formulario.template

    # Buscar todas as respostas para este formulário
    @respostas = Respostum.where(formulario: @formulario)

    # Calcular estatísticas para cada pergunta
    @estatisticas = {}
    @template.pergunta.each do |pergunta|
      respostas_pergunta = @respostas.where(pergunta: pergunta)

      case pergunta.tipo
      when 'subjetiva'
        @estatisticas[pergunta.id] = {
          tipo: 'subjetiva',
          total_respostas: respostas_pergunta.count,
          respostas_texto: respostas_pergunta.where.not(resposta_texto: [nil, '']).pluck(:resposta_texto)
        }
      when 'multipla_escolha'
        opcoes_stats = {}
        pergunta.opcoes_pergunta.each do |opcao|
          opcoes_stats[opcao.id] = {
            texto: opcao.texto,
            count: respostas_pergunta.where(opcao: opcao).count
          }
        end
        @estatisticas[pergunta.id] = {
          tipo: pergunta.tipo,
          total_respostas: respostas_pergunta.count,
          opcoes: opcoes_stats
        }
      when 'verdadeiro_falso'
        # Para verdadeiro/falso, usar resposta_texto
        opcoes_stats = {}
        ['Verdadeiro', 'Falso'].each do |opcao_texto|
          opcoes_stats[opcao_texto] = {
            texto: opcao_texto,
            count: respostas_pergunta.where(resposta_texto: opcao_texto).count
          }
        end
        @estatisticas[pergunta.id] = {
          tipo: 'verdadeiro_falso',
          total_respostas: respostas_pergunta.count,
          opcoes: opcoes_stats
        }
      end
    end

    # Estatísticas gerais
    @total_submissoes = SubmissaoConcluida.where(formulario: @formulario).count
    @total_respostas = @respostas.count
  end

  private

  def process_respostas
    uuid_anonimo = SecureRandom.uuid
    respostas_params = params.require(:respostas).permit!

    ActiveRecord::Base.transaction do
      respostas_params.each do |pergunta_id, resposta_valor|
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
    redirect_to evaluation_path(@formulario), alert: "Erro ao salvar respostas: #{e.message}"
  end
end
