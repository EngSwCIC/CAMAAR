# Gerencia o cadastro de usuários e o fluxo de resposta a formulários de avaliação.
#
# As ações de CRUD (+index+, +show+, +new+, +edit+, +create+, +update+, +destroy+)
# são restritas a administradores. As ações +avaliacoes+, +responder_formulario+ e
# +submeter_resposta+ são acessíveis a qualquer usuário autenticado e compõem o
# fluxo pelo qual docentes e discentes visualizam e respondem formulários de avaliação
# das suas turmas.
class UsuariosController < ApplicationController
  before_action :require_login
  before_action :require_admin, except: [ :avaliacoes, :responder_formulario, :submeter_resposta ]
  before_action :set_usuario, only: %i[ show edit update destroy ]

  # Lista as avaliações (formulários) das turmas do usuário.
  #
  # @return [void]
  # @note Lê o parâmetro +:usuario_id+ da rota. Popula +@turmas+ conforme o tipo do
  #   usuário (+Docente+ ou +Discente+); demais tipos resultam em coleção vazia.
  def avaliacoes
    @usuario = Usuario.find(params[:usuario_id])

    if @usuario.is_a?(Docente)
      @turmas = @usuario.turmas
    elsif @usuario.is_a?(Discente)
      @turmas = @usuario.turmas
    else
      @turmas = Turma.none
    end

    @avaliacoes = Formulario
      .joins(:turma)
      .where(turma: @turmas)
      .includes(turma: { disciplina: :departamento, docentes: [] })
  end

  # Exibe o formulário de avaliação para preenchimento pelo usuário.
  #
  # @return [void]
  # @note Lê +:usuario_id+ e +:formulario_id+ da rota. Redireciona para a lista de
  #   avaliações com aviso se o usuário já tiver respondido o formulário.
  def responder_formulario
    @usuario = Usuario.find(params[:usuario_id])
    @formulario = Formulario.includes(elemento_forms: :campo_forms).find(params[:formulario_id])

    if RespostaForm.exists?(formulario: @formulario, usuario: current_user)
      redirect_to usuarios_avaliacoes_path(@usuario), notice: "Você já respondeu este formulário."
    end
  end

  # Persiste as respostas do usuário ao formulário de avaliação.
  #
  # @return [void]
  # @note Lê +:usuario_id+, +:formulario_id+ e o hash +:respostas+ da requisição.
  #   Redireciona com alerta se o formulário já foi respondido ou se alguma questão
  #   obrigatória estiver em branco. Em caso de sucesso, cria um +RespostaForm+ e os
  #   +RespostaElem+ correspondentes a cada elemento dentro de uma transação, depois
  #   redireciona para a lista de avaliações. Em caso de erro de validação, re-renderiza
  #   o formulário com mensagem de alerta.
  def submeter_resposta
    @usuario = Usuario.find(params[:usuario_id])
    @formulario = Formulario.includes(elemento_forms: :campo_forms).find(params[:formulario_id])

    if RespostaForm.exists?(formulario: @formulario, usuario: current_user)
      redirect_to usuarios_avaliacoes_path(@usuario), alert: "Você já respondeu este formulário." and return
    end

    respostas_em_branco = @formulario.elemento_forms.order(:ordem).any? do |ef|
      params.dig(:respostas, ef.id.to_s).blank?
    end

    if respostas_em_branco
      flash.now[:alert] = "Por favor, responda todas as perguntas obrigatórias"
      render :responder_formulario, status: :unprocessable_content and return
    end

    resposta_form = RespostaForm.new(
      formulario: @formulario,
      usuario: current_user,
      data_submissao: Date.today
    )

    ActiveRecord::Base.transaction do
      resposta_form.save!

      @formulario.elemento_forms.order(:ordem).each do |ef|
        resposta_val = params.dig(:respostas, ef.id.to_s)
        next if resposta_val.blank?

        if ef.tipo == "Texto"
          resposta_form.resposta_elems.create!(
            elemento_form: ef,
            texto_resposta: resposta_val
          )
        else
          campo = ef.campo_forms.find_by(id: resposta_val)
          next unless campo

          resposta_form.resposta_elems.create!(
            elemento_form: ef,
            campo_form: campo,
            texto_resposta: campo.enunciado
          )
        end
      end
    end

    redirect_to usuarios_avaliacoes_path(@usuario), notice: "Respostas enviadas com sucesso!"
  rescue ActiveRecord::RecordInvalid => e
    @formulario = Formulario.includes(elemento_forms: :campo_forms).find(params[:formulario_id])
    flash.now[:alert] = "Erro ao salvar respostas: #{e.message}"
    render :responder_formulario, status: :unprocessable_content
  end

  # Lista todos os usuários cadastrados.
  #
  # @return [void]
  def index
    @usuarios = Usuario.all
  end

  # Exibe os detalhes de um usuário específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo usuário.
  #
  # @return [void]
  def new
    @usuario = Usuario.new
  end

  # Exibe o formulário de edição de um usuário existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo usuário com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o usuário no banco de dados. Em caso de sucesso, redireciona para a
  #   página do usuário; em caso de falha, re-renderiza o formulário de criação.
  def create
    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to @usuario, notice: "Usuario was successfully created." }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @usuario.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um usuário existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do usuário; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to @usuario, notice: "Usuario was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @usuario.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um usuário do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de usuários após a exclusão.
  def destroy
    @usuario.destroy!

    respond_to do |format|
      format.html { redirect_to usuarios_path, notice: "Usuario was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o usuário pelo +:id+ da rota e o atribui a +@usuario+.
  #
  # @return [void]
  def set_usuario
    @usuario = Usuario.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de usuário.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do usuário
  def usuario_params
    params.expect(usuario: [ :matricula, :email, :nome, :formacao, :type ])
  end
end
