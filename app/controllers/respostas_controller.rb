class RespostasController < ApplicationController
  before_action :require_login

  def create
    @formulario = find_formulario
    return unless @formulario

    estudante = find_estudante
    return unless estudante

    return unless estudante_tem_permissao?(estudante, @formulario)
    return unless resposta_unica?(@formulario)

    @pergunta_formularios = @formulario.pergunta_formularios
    return unless respostas_preenchidas?(params[:respostas])

    resposta = RespostaFormulario.new(formulario: @formulario, usuario: current_usuario)

    if resposta.save
      redirect_to avaliacoes_path, notice: "Sua resposta foi registrada com sucesso."
    else
      flash.now[:alert] = "Erro ao registrar resposta."
      render "formularios/show", status: :unprocessable_entity
    end
  end

  private

  # Busca o formulário pelo ID informado em <tt>params[:formulario_id]</tt>.
  #
  # Se o formulário não for encontrado, redireciona para +avaliacoes_path+
  # com alerta "Formulário não encontrado." e retorna +nil+,
  # interrompendo o fluxo da ação +create+.
  #
  # ==== Retorno
  # [Formulario] se encontrado.
  # [nil] se não encontrado (com redirecionamento).
  def find_formulario
    @formulario = Formulario.find_by(id: params[:formulario_id])
    unless @formulario
      redirect_to avaliacoes_path, alert: "Formulário não encontrado."
      return nil
    end
    @formulario
  end

  # Obtém o perfil de estudante associado ao usuário autenticado.
  #
  # Se o usuário não possuir perfil de estudante, redireciona para
  # +avaliacoes_path+ com alerta e retorna +nil+,
  # interrompendo o fluxo da ação +create+.
  #
  # ==== Retorno
  # [Estudante] perfil de estudante do usuário atual.
  # [nil] se o usuário não for estudante (com redirecionamento).
  def find_estudante
    estudante = current_usuario.estudante
    unless estudante
      redirect_to avaliacoes_path, alert: "Você não tem permissão para responder este formulário."
      return nil
    end
    estudante
  end

  # Verifica se o estudante possui permissão para responder o formulário.
  #
  # Condições necessárias:
  # * O estudante possui matrícula ativa (não trancada) na turma do formulário;
  # * O formulário está marcado como público para estudantes
  #   (<tt>publico_estudante == true</tt>).
  #
  # Caso não tenha permissão, redireciona para +avaliacoes_path+
  # com alerta e retorna +false+, interrompendo o fluxo da ação +create+.
  #
  # ==== Parâmetros
  # [estudante]  Perfil de estudante do usuário atual.
  # [formulario] Formulário que se deseja responder.
  #
  # ==== Retorno
  # [true]  se o estudante tem permissão.
  # [false] se não tem permissão (com redirecionamento).
  def estudante_tem_permissao?(estudante, formulario)
    turma_ids = estudante.matriculas.where(trancado: [ false, nil ]).pluck(:turma_id)
    unless turma_ids.include?(formulario.turma_id) && formulario.publico_estudante
      redirect_to avaliacoes_path, alert: "Você não tem permissão para responder este formulário."
      return false
    end
    true
  end

  # Verifica se o usuário atual já respondeu este formulário.
  #
  # Regra de negócio: cada usuário pode responder um mesmo formulário apenas uma vez.
  #
  # Caso já tenha respondido, redireciona para +avaliacoes_path+
  # com alerta e retorna +false+, interrompendo o fluxo da ação +create+.
  #
  # ==== Parâmetros
  # [formulario] Formulário a ser verificado.
  #
  # ==== Retorno
  # [true]  se o usuário ainda não respondeu.
  # [false] se já respondeu (com redirecionamento).
  def resposta_unica?(formulario)
    if RespostaFormulario.exists?(formulario: formulario, usuario: current_usuario)
      redirect_to avaliacoes_path, alert: "Você já respondeu este formulário."
      return false
    end
    true
  end

  # Verifica se todas as perguntas obrigatórias do formulário foram preenchidas.
  #
  # Considera uma pergunta como não respondida quando o valor associado
  # ao seu ID está em branco no hash <tt>params[:respostas]</tt>.
  #
  # Se houver perguntas não respondidas, define mensagem de alerta via
  # <tt>flash.now</tt> e renderiza a view +formularios/show+ com status
  # HTTP 422 (Unprocessable Entity), interrompendo o fluxo da ação +create+.
  #
  # ==== Parâmetros
  # [respostas_params] Hash com as respostas enviadas (<tt>params[:respostas]</tt>).
  #
  # ==== Retorno
  # [true]  se todas as perguntas foram respondidas.
  # [false] se há perguntas em branco (com renderização da view).
  def respostas_preenchidas?(respostas_params)
    answers = respostas_params || {}
    missing = @pergunta_formularios.any? { |pf| answers[pf.id.to_s].blank? }

    if missing
      flash.now[:alert] = "Por favor, responda todas as questões obrigatórias."
      render "formularios/show", status: :unprocessable_entity
      return false
    end
    true
  end
end
