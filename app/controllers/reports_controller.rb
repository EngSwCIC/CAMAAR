# frozen_string_literal: true

# Controller para relatórios de avaliações
class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_professor_or_admin!

  # GET /reports
  #
  # Exibe a página de relatórios com estatísticas gerais.
  #
  def index
    # Para professores, mostrar apenas relatórios de suas disciplinas
    # Para admins, mostrar todos os relatórios
    @formularios = if current_user.professor?
                     formularios_do_professor
                   else
                     Formulario.all
                   end

    @estatisticas_gerais = calcular_estatisticas_gerais
  end

  # GET /reports/:id
  #
  # Exibe o relatório detalhado de um formulário específico.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do formulário.
  #
  def show
    @formulario = find_formulario
    @estatisticas = calcular_estatisticas_formulario(@formulario)
    @respostas = obter_respostas_formulario(@formulario)
  end

  private

  def ensure_professor_or_admin!
    return if current_user.professor? || current_user.admin?

    redirect_to root_path, alert: 'Acesso negado. Apenas professores e administradores podem ver relatórios.'
  end

  def formularios_do_professor
    # Buscar formulários das disciplinas que o professor leciona
    disciplinas_ids = current_user.disciplinas_como_professor.pluck(:id)
    Formulario.where(disciplina_id: disciplinas_ids)
  end

  def find_formulario
    if current_user.professor?
      # Professor só pode ver relatórios de suas disciplinas
      disciplinas_ids = current_user.disciplinas_como_professor.pluck(:id)
      Formulario.where(disciplina_id: disciplinas_ids).find(params[:id])
    else
      # Admin pode ver qualquer formulário
      Formulario.find(params[:id])
    end
  end

  def calcular_estatisticas_gerais
    total_formularios = @formularios.count
    total_respostas = SubmissaoConcluida.joins(:formulario).where(formulario: @formularios).count

    formularios_com_respostas = @formularios.joins(:submissoes_concluidas).distinct.count
    taxa_participacao = if total_formularios.positive?
                          (formularios_com_respostas.to_f / total_formularios * 100).round(1)
                        else
                          0
                        end

    {
      total_formularios: total_formularios,
      total_respostas: total_respostas,
      formularios_com_respostas: formularios_com_respostas,
      taxa_participacao: taxa_participacao
    }
  end

  def calcular_estatisticas_formulario(formulario)
    total_respostas = formulario.submissoes_concluidas.count
    total_perguntas = formulario.template.pergunta.count

    # Calcular tempo médio de resposta se houver timestamps
    tempo_medio = calcular_tempo_medio_resposta(formulario)

    {
      total_respostas: total_respostas,
      total_perguntas: total_perguntas,
      tempo_medio: tempo_medio
    }
  end

  def calcular_tempo_medio_resposta(_formulario)
    # Se houver campos de timestamp nas submissões, calcular aqui
    # Por enquanto, retornar nil
    nil
  end

  def obter_respostas_formulario(formulario)
    # Obter respostas agrupadas por pergunta
    respostas_por_pergunta = {}

    formulario.template.pergunta.each do |pergunta|
      respostas = Respostum.where(pergunta: pergunta, formulario: formulario)

      respostas_por_pergunta[pergunta.id] = if pergunta.multipla_escolha? || pergunta.verdadeiro_falso?
                                              # Agrupar respostas por opção para múltipla escolha e verdadeiro/falso
                                              respostas.group(:opcao_id).count.transform_keys do |key|
                                                OpcoesPerguntum.find(key).texto if key
                                              end
                                            else
                                              # Para perguntas subjetivas, listar as respostas
                                              respostas.pluck(:resposta_texto)
                                            end
    end

    respostas_por_pergunta
  end
end
