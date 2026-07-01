# frozen_string_literal: true

class AvaliacoesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_avaliacao, only: %i[responder submeter]

  ##
  # Lista todas as avaliações pendentes que pertencem às turmas nas quais o usuário autenticado está matriculado.
  #
  # Argumentos:
  # - Nenhum. Consome indiretamente o +current_user.id+ da sessão.
  #
  # Retorno:
  # - Renderiza a view +pendentes+.
  # - Popula a variável de instância +@avaliacoes_pendentes+ com a coleção de avaliações.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: Realiza apenas operações de leitura (SELECT), cruzando +Avaliacao+, +ParticipacaoTurma+ e +Formulario+.
  # - *Redirecionamento*: Bloqueia e redireciona caso o usuário não esteja autenticado (via +before_action+).
  def pendentes
    @avaliacoes_pendentes = Avaliacao
      .pendentes
      .joins(:participacao_turma)
      .where(participacoes_turmas: { usuario_id: current_user.id })
      .includes(formulario: { turma: :materia })
  end

  ##
  # Prepara e exibe a tela contendo o formulário e as questões para que o discente possa responder à avaliação.
  #
  # Argumentos:
  # - Recebe o ID da avaliação através de +params[:id]+ (processado no +before_action+).
  #
  # Retorno:
  # - Renderiza a view +responder+.
  # - Popula as variáveis de instância +@formulario+ e +@questoes+.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: Apenas leitura.
  # - *Redirecionamento*: Se a avaliação já constar como respondida, interrompe o fluxo e redireciona para a lista de pendentes com um alerta.
  def responder
    if @avaliacao.respondida?
      redirect_to avaliacoes_pendentes_path,
        alert: "Esta avaliação já foi respondida."
      return
    end

    preparar_formulario_resposta
  end

  ##
  # Processa a submissão do formulário preenchido pelo discente, validando se as regras foram cumpridas
  # antes de repassar para a transação de salvamento.
  #
  # Argumentos:
  # - Recebe os dados do formulário preenchido através do +params[:respostas]+.
  # - Recebe o ID da avaliação via +params[:id]+ (processado no +before_action+).
  #
  # Retorno:
  # - Em caso de sucesso: Chama o método de salvamento que redireciona o usuário.
  # - Em caso de falha de validação: Renderiza novamente a view +responder+ com status HTTP +unprocessable_entity+.
  #
  # Efeitos colaterais:
  # - *Redirecionamento*: Redireciona para a lista de pendentes caso a avaliação já tenha sido respondida previamente.
  # - *Banco de Dados*: Não altera o banco diretamente neste escopo, repassando a responsabilidade de escrita para +salvar_respostas_e_finalizar+.
  def submeter
    resultado = Avaliacoes::SubmitResponse.call(
      avaliacao: @avaliacao,
      respostas_params: params[:respostas]
    )

    return redirecionar_avaliacao_respondida if resultado.already_answered?
    return redirecionar_avaliacao_registrada if resultado.success?

    preparar_formulario_resposta
    renderizar_erro_resposta
  end

  private

  ##
  # Método de segurança que busca a avaliação solicitada e garante que ela pertence às turmas do usuário atual.
  #
  # Argumentos:
  # - Consome +params[:id]+ da rota atual.
  # - Consome o usuário logado via +current_user+.
  #
  # Retorno:
  # - Configura a variável de instância +@avaliacao+.
  #
  # Efeitos colaterais:
  # - *Redirecionamento*: Se a avaliação não for encontrada ou não pertencer ao usuário, resgata a exceção +ActiveRecord::RecordNotFound+ e redireciona com alerta.
  def set_avaliacao
    participacao_ids = ParticipacaoTurma
                         .where(usuario: current_user)
                         .pluck(:id)

    @avaliacao = Avaliacao.find_by!(id: params[:id],
                                    participacao_turma_id: participacao_ids)
  rescue ActiveRecord::RecordNotFound
    redirect_to avaliacoes_pendentes_path, alert: "Avaliação não encontrada."
  end

  def preparar_formulario_resposta
    @formulario = @avaliacao.formulario
    @questoes = Avaliacoes::SubmitResponse.questions_for(@avaliacao)
  end

  def redirecionar_avaliacao_respondida
    redirect_to avaliacoes_pendentes_path,
      alert: "Esta avaliação já foi respondida."
  end

  def redirecionar_avaliacao_registrada
    redirect_to avaliacoes_pendentes_path,
      notice: "Avaliação registrada com sucesso."
  end

  def renderizar_erro_resposta
    flash.now[:alert] = "Todas as questões obrigatórias devem ser preenchidas."
    render :responder, status: :unprocessable_entity
  end
end
