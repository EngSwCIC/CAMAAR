class TurmaFormulariosController < ApplicationController
  before_action :require_coordinator

  def create
    @turma = find_turma_and_authorize(params[:turma_id])
    return unless @turma

    formulario = Formulario.find_by(id: params[:formulario_id])
    if formulario
      redirect_to departamento_turma_path(@turma), notice: "Formulário associado com sucesso."
    else
      redirect_to departamento_turma_path(@turma), alert: "Formulário não encontrado."
    end
  end

  def destroy
    formulario = find_formulario_and_authorize(params[:id])
    return unless formulario

    @turma = formulario.turma
    redirect_to departamento_turma_path(@turma), notice: "Associação de formulário removida com sucesso."
  end

  private

  # Retorna os IDs das turmas que pertencem ao departamento do usuário atual.
  #
  # O resultado é memoizado na variável de instância
  # <tt>@turmas_do_departamento_ids</tt> para evitar múltiplas consultas
  # ao banco de dados durante a mesma requisição.
  #
  # A cadeia de associações percorrida é:
  # <tt>current_usuario -> admin -> departamento -> materias -> turmas -> id</tt>.
  #
  # ==== Retorno
  # [Array<Integer>] Lista de IDs das turmas do departamento.
  #   Retorna um array vazio se o usuário não for admin ou não tiver departamento.
  def turmas_do_departamento_ids
    @turmas_do_departamento_ids ||= begin
      departamento = current_usuario.admin&.departamento
      departamento&.materias&.flat_map(&:turmas)&.map(&:id) || []
    end
  end

  # Verifica se um ID de turma pertence ao departamento do usuário atual.
  #
  # Utiliza o método <tt>turmas_do_departamento_ids</tt> para obter
  # a lista de IDs autorizados.
  #
  # ==== Parâmetros
  # [turma_id] ID da turma a ser verificada.
  #
  # ==== Retorno
  # [true]  se a turma pertence ao departamento.
  # [false] se a turma não pertence ao departamento.
  def turma_pertence_ao_departamento?(turma_id)
    turmas_do_departamento_ids.include?(turma_id)
  end

  # Localiza uma turma pelo ID e verifica se ela pertence ao departamento do usuário.
  #
  # Método utilizado como guarda nas ações do controller:
  # * Busca a turma por <tt>Turma.find_by(id: turma_id)</tt>;
  # * Verifica se a turma pertence ao departamento via
  #   <tt>turma_pertence_ao_departamento?</tt>.
  #
  # Se a turma não for encontrada ou não pertencer ao departamento,
  # redireciona para +departamento_path+ com mensagem de alerta
  # e retorna +nil+, interrompendo o fluxo da ação.
  #
  # ==== Parâmetros
  # [turma_id] ID da turma a ser localizada e autorizada.
  #
  # ==== Retorno
  # [Turma] se encontrada e autorizada.
  # [nil]   se não encontrada ou não autorizada (com redirecionamento).
  def find_turma_and_authorize(turma_id)
    turma = Turma.find_by(id: turma_id)
    unless turma && turma_pertence_ao_departamento?(turma.id)
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento."
      return nil
    end
    turma
  end

  # Localiza um formulário pelo ID e verifica se sua turma pertence ao
  # departamento do usuário.
  #
  # Método utilizado como guarda nas ações do controller:
  # * Busca o formulário por <tt>Formulario.find_by(id: formulario_id)</tt>;
  # * Verifica se a turma associada ao formulário
  #   (<tt>formulario.turma_id</tt>) pertence ao departamento via
  #   <tt>turma_pertence_ao_departamento?</tt>.
  #
  # Se o formulário não for encontrado ou sua turma não pertencer ao
  # departamento, redireciona para +departamento_path+ com mensagem de
  # alerta e retorna +nil+, interrompendo o fluxo da ação.
  #
  # ==== Parâmetros
  # [formulario_id] ID do formulário a ser localizado e autorizado.
  #
  # ==== Retorno
  # [Formulario] se encontrado e autorizado.
  # [nil]        se não encontrado ou não autorizado (com redirecionamento).
  def find_formulario_and_authorize(formulario_id)
    formulario = Formulario.find_by(id: formulario_id)
    unless formulario && turma_pertence_ao_departamento?(formulario.turma_id)
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento."
      return nil
    end
    formulario
  end
end
