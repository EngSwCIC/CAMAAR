require 'csv'

# Gerencia o ciclo de vida das avaliações:
# criação, resposta, resultados e exportação em CSV.
#
# Todas as actions exigem autenticação via +authenticate_user!+.
# As actions +new+, +create+, +resultados+ e +exportar_csv+ são
# restritas a administradores via +require_admin!+.
class AvaliacoesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!,
                only: [:new, :create, :resultados, :exportar_csv]
  before_action :set_avaliacao,
                only: [:show, :responder, :submeter,
                       :resultados, :exportar_csv]

  layout 'authenticated'

  # Lista as avaliações visíveis para o usuário autenticado.
  #
  # Não recebe argumentos. Retorna implicitamente a view +index+,
  # atribuindo a +@avaliacoes+ todas as avaliações (admin) ou apenas
  # as avaliações pendentes das turmas do discente (usuário comum).
  # Não altera o banco de dados.
  def index
    @avaliacoes = AvaliacaoService.avaliacoes_para(current_user)
  end

  # Exibe os detalhes de uma avaliação.
  #
  # Não recebe argumentos; usa +@avaliacao+ carregado pelo +before_action+.
  # Retorna implicitamente a view +show+. Não altera o banco de dados.
  def show
  end

  # Exibe o formulário de criação de uma nova avaliação.
  #
  # Não recebe argumentos. Inicializa +@avaliacao+, +@templates+ e +@turmas+
  # para popular o formulário. Retorna implicitamente a view +new+.
  # Não altera o banco de dados.
  def new
    @avaliacao = Avaliacao.new
    carregar_formulario
  end

  # Cria uma nova avaliação a partir dos parâmetros do formulário.
  #
  # Não recebe argumentos; lê +params[:avaliacao]+.
  # Retorna redirecionamento para +avaliacoes_path+ com mensagem de sucesso
  # quando salvo, ou renderiza novamente a view +new+ com status 422
  # quando inválido.
  # Efeito colateral: persiste um registro de +Avaliacao+ no banco de dados
  # em caso de sucesso.
  def create
    @avaliacao = Avaliacao.new(avaliacao_params)

    if @avaliacao.save
      redirect_to avaliacoes_path,
                  notice: 'Formulário disponibilizado para a turma.'
    else
      carregar_formulario
      render :new, status: :unprocessable_entity
    end
  end

  # Exibe o formulário de resposta de uma avaliação.
  #
  # Não recebe argumentos; usa +@avaliacao+ carregado pelo +before_action+.
  # Retorna redirecionamento para +avaliacoes_path+ com alerta se o usuário
  # já respondeu, ou renderiza a view +responder+ com +@questoes+ atribuído.
  # Não altera o banco de dados.
  def responder
    if AvaliacaoService.ja_respondeu?(@avaliacao, current_user)
      redirect_to avaliacoes_path,
                  alert: 'Você já respondeu este formulário.'
    else
      @questoes = @avaliacao.template.questoes
    end
  end

  # Processa a submissão das respostas de uma avaliação.
  #
  # Não recebe argumentos; lê +params[:respostas]+ e usa +@avaliacao+
  # carregado pelo +before_action+.
  # Possui três possibilidades de retorno:
  # - Redireciona para +avaliacoes_path+ com alerta se já respondeu;
  # - Redireciona para +avaliacoes_path+ com notice de sucesso se salvo;
  # - Renderiza novamente a view +responder+ com status 422 se inválido.
  # Efeito colateral: persiste registros de +Resposta+ no banco de dados
  # em caso de sucesso.
  def submeter
    resultado = AvaliacaoService.submeter_respostas(
      avaliacao: @avaliacao,
      user: current_user,
      respostas_params: params[:respostas]
    )

    case resultado
    when :ja_respondeu
      redirect_to avaliacoes_path,
                  alert: 'Você já respondeu este formulário.'

    when true
      redirect_to avaliacoes_path,
                  notice: 'Respostas enviadas com sucesso.'

    else
      render_responder_com_erro
    end
  end

  # Exibe os resultados consolidados de uma avaliação.
  #
  # Não recebe argumentos; usa +@avaliacao+ carregado pelo +before_action+.
  # Atribui +@questoes+ com as questões e suas respostas, e +@total_respostas+
  # com o número de respondentes únicos. Retorna implicitamente a view
  # +resultados+. Não altera o banco de dados.
  def resultados
    @questoes = AvaliacaoService.questoes_resultado(@avaliacao)
    @total_respostas = AvaliacaoService.total_respostas(@avaliacao)
  end

  # Exporta as respostas de uma avaliação em formato CSV.
  #
  # Não recebe argumentos; usa +@avaliacao+ carregado pelo +before_action+.
  # Retorna redirecionamento para +resultados_avaliacao_path+ com alerta
  # quando não há respostas, ou envia o arquivo CSV para download com
  # nome +avaliacao_<id>.csv+.
  # Não altera o banco de dados.
  def exportar_csv
    csv = AvaliacaoService.exportar_csv(@avaliacao)

    unless csv
      redirect_to resultados_avaliacao_path(@avaliacao),
                  alert: 'Não existem respostas para exportar'
      return
    end

    send_data csv,
              filename: "avaliacao_#{@avaliacao.id}.csv",
              type: 'text/csv'
  end

  private


  # Carrega templates e turmas necessários ao formulário de criação/edição.
  #
  # Não recebe argumentos. Atribui +@templates+ e +@turmas+.
  # Não altera o banco de dados.
  def carregar_formulario
    @templates = Template.all
    @turmas = Turma.includes(:disciplina).all
  end

  # Renderiza novamente o formulário de resposta quando a submissão é inválida.
  #
  # Não recebe argumentos. Atribui +@questoes+, define mensagem de alerta
  # e renderiza a view +responder+ com status HTTP 422.
  # Não altera o banco de dados.
  def render_responder_com_erro
    @questoes = @avaliacao.template.questoes
    flash.now[:alert] = 'Preencha todas as questões.'
    render :responder,
           status: :unprocessable_entity
  end

  # Carrega a avaliação referenciada pelo parâmetro +:id+ da rota.
  #
  # Não recebe argumentos; usa +params[:id]+. Atribui +@avaliacao+.
  # Levanta +ActiveRecord::RecordNotFound+ se o id não existir.
  # Não altera o banco de dados.
  def set_avaliacao
    @avaliacao = Avaliacao.find(params[:id])
  end

  # Filtra os parâmetros permitidos para criar ou atualizar uma avaliação.
  #
  # Não recebe argumentos; lê +params[:avaliacao]+. Retorna um objeto
  # +ActionController::Parameters+ com os campos +:template_id+, +:turma_id+,
  # +:data_inicio+, +:data_fim+ e +:tipo+. Não altera o banco de dados.
  def avaliacao_params
    params.require(:avaliacao).permit(
      :template_id,
      :turma_id,
      :data_inicio,
      :data_fim,
      :tipo
    )
  end
end