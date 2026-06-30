##
# Define a controller para gerenciar respostas de formulários, incluindo criação e validação de respostas.
class RespostasController < ApplicationController
  before_action :authenticate_user!

  ##
  # a. Descrição: Cria respostas para um formulário específico, garantindo que o usuário tenha permissão e que todas as questões obrigatórias sejam respondidas.
  # b. Argumentos: Recebe 'formulario_id' (Integer) e 'respostas' (Hash) como parâmetros.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Redireciona o usuário para a página de formulários ou para o formulário específico, emitindo mensagens de sucesso ou erro.
  def create
    @formulario = Formulario.find(params[:formulario_id])
    respostas = params[:respostas] || {}

    return if acesso_negado?(@formulario)
    return if respostas_incompletas?(@formulario, respostas)

    processar_salvamento_respostas(@formulario, respostas)
  end

  private

  ##
  # a. Descrição: Verifica se o usuário tem permissão para responder o formulário e gerencia o redirecionamento.
  # b. Argumentos: Recebe 'formulario' (Formulario).
  # c. Retorno: Retorna um booleano (true se o acesso for negado, false caso contrário).
  # d. Efeitos colaterais: Interrompe o fluxo e redireciona a requisição caso o usuário não possa responder.
  def acesso_negado?(formulario)
    unless participante?(formulario)
      redirect_to formularios_path, alert: "Você não está matriculado nesta turma."
      return true
    end

    if formulario.respondido_por?(current_user)
      redirect_to formularios_path, alert: "Você já respondeu este formulário."
      return true
    end

    false
  end

  ##
  # a. Descrição: Verifica se todas as questões obrigatórias do formulário foram preenchidas.
  # b. Argumentos: Recebe 'formulario' (Formulario) e 'respostas' (Hash).
  # c. Retorno: Retorna um booleano (true se faltarem respostas, false caso contrário).
  # d. Efeitos colaterais: Pode alterar o flash[:alert] e redirecionar a página se a validação falhar.
  def respostas_incompletas?(formulario, respostas)
    expected_question_count = formulario.questions.count
    
    if respostas.keys.size < expected_question_count || respostas.values.any?(&:blank?)
      flash[:alert] = "Existem questões obrigatórias não respondidas."
      redirect_to formulario_path(formulario)
      return true
    end

    false
  end

  ##
  # a. Descrição: Executa a gravação em lote das respostas enviadas pelo usuário dentro de uma transação.
  # b. Argumentos: Recebe 'formulario' (Formulario) e 'respostas' (Hash).
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Faz inserções no banco de dados e redireciona a requisição informando sucesso ou falha.
  def processar_salvamento_respostas(formulario, respostas)
    Resposta.transaction do
      respostas.each do |question_id, valor|
        Resposta.create!(
          formulario: formulario,
          user: current_user,
          question_id: question_id,
          valor: valor
        )
      end
    end
    
    redirect_to formularios_path, notice: "Respostas enviadas. Obrigado!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to formulario_path(formulario), alert: "Erro ao enviar respostas: #{e.message}"
  end

  ##
  # a. Descrição: Avalia se o usuário atual é um participante da turma associada ao formulário.
  # b. Argumentos: Recebe 'formulario' (Formulario).
  # c. Retorno: Retorna um booleano (true se o usuário for um participante, false caso contrário).
  # d. Efeitos colaterais: Nenhum.
  def participante?(formulario)
    current_user.enrollments.discentes.exists?(turma_id: formulario.turma_id)
  end
end