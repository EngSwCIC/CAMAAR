##
# Gerencia formulários de avaliação, apresenta pendências aos participantes e
# disponibiliza resultados e exportação aos administradores.
class FormulariosController < ApplicationController
  before_action :require_admin!, only: %i[ new create destroy exportar_csv ]
  before_action :set_formulario, only: %i[ show destroy exportar_csv ]
  before_action :authorize_formulario_access!, only: %i[ destroy ]

  ##
  # Lista os formulários do administrador ou as avaliações pendentes do participante.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML ou JSON construída pelo Rails.
  #
  # Efeitos colaterais: consulta o banco e define +@formularios+ e
  # +@formularios_pendentes+ para a view.
  def index
    # Issue 110: Visualizar os formulários criados (Listagem geral)
    @formularios = current_admin ? current_admin.formularios : []

    # Issue 109: Visualizar os formulários não respondidos das turmas, respeitando
    # o papel (discente/docente) do usuário em cada turma
    @formularios_pendentes = current_user ? formularios_pendentes_para(current_user) : []
  end

  ##
  # Exibe um formulário para resposta ou, para administradores, seus resultados.
  #
  # Não recebe argumentos explícitos; usa o formulário carregado por +params[:id]+.
  #
  # Retorna a resposta HTML ou JSON construída pelo Rails.
  #
  # Efeitos colaterais: consulta submissões e respostas e define variáveis para a view.
  def show
    if current_admin
      @resultados = @formulario.questaos.includes(respostas: { submissao: :user })
      @tem_submissoes = Submissao.where(formulario: @formulario).exists?
    end
  end

  ##
  # Prepara a tela de criação de um formulário.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML construída pelo Rails.
  #
  # Efeitos colaterais: instancia um formulário, consulta templates e turmas e define
  # as coleções usadas pela view.
  def new
    @formulario = Formulario.new
    @templates = current_admin.templates
    @course_classes = CourseClass.all
  end

  ##
  # Cria um formulário a partir de um template e clona suas questões.
  #
  # Não recebe argumentos explícitos; utiliza os atributos permitidos da requisição.
  #
  # Retorna uma resposta de redirecionamento em caso de sucesso ou uma resposta
  # com status de conteúdo não processável quando houver erros.
  #
  # Efeitos colaterais: persiste o formulário e suas questões ou renderiza novamente
  # a tela com as mensagens de validação.
  def create
    result = Formularios::CreateFromTemplate.new(admin: current_admin, params: formulario_params).call
    @formulario = result.formulario

    result.success? ? render_create_success : render_create_failure
  end

  ##
  # Exclui o formulário carregado e seus registros dependentes.
  #
  # Não recebe argumentos explícitos; usa o formulário carregado por +params[:id]+.
  #
  # Retorna uma resposta de redirecionamento com status +303 See Other+.
  #
  # Efeitos colaterais: remove registros do banco e define uma mensagem de sucesso.
  def destroy
    @formulario.destroy!
    redirect_to formularios_path, notice: "Formulário deletado com sucesso.", status: :see_other
  end

  ##
  # Exporta as questões e respostas do formulário em um arquivo CSV.
  #
  # Não recebe argumentos explícitos; usa o formulário carregado por +params[:id]+.
  #
  # Retorna a resposta de arquivo produzida por +send_data+.
  #
  # Efeitos colaterais: consulta respostas e envia dados CSV para download pelo cliente.
  def exportar_csv
    send_data gerar_csv,
              filename: "respostas_formulario_#{@formulario.id}.csv",
              type: "text/csv"
  end

  private
    ##
    # Carrega o formulário indicado na rota.
    #
    # Não recebe argumentos explícitos; utiliza +params[:id]+.
    #
    # Retorna o Formulario encontrado.
    #
    # Efeitos colaterais: consulta o banco, define +@formulario+ e lança
    # ActiveRecord::RecordNotFound quando o identificador não existe.
    def set_formulario
      @formulario = Formulario.find(params.expect(:id))
    end

    ##
    # Verifica se o formulário pertence ao administrador atual.
    #
    # Não recebe argumentos explícitos; utiliza +@formulario+ e +current_admin+.
    #
    # Retorna +nil+ quando autorizado ou o resultado do redirecionamento quando negado.
    #
    # Efeitos colaterais: pode redirecionar para a listagem e definir uma mensagem de alerta.
    def authorize_formulario_access!
      redirect_to formularios_path, alert: "Você não tem acesso a esse formulário" unless @formulario.admin_id == current_admin.id
    end

    ##
    # Filtra os atributos aceitos para criação de formulário.
    #
    # Não recebe argumentos explícitos; lê +params[:formulario]+.
    #
    # Retorna ActionController::Parameters com os atributos permitidos.
    #
    # Efeitos colaterais: pode lançar ActionController::ParameterMissing quando a chave
    # obrigatória não estiver presente.
    def formulario_params
      params.expect(formulario: [ :title, :status, :template_id, :course_class_id ])
    end

    ##
    # Localiza formulários ainda não respondidos e compatíveis com o papel do usuário em cada turma.
    #
    # === Argumentos
    #
    # +user+:: User participante cujas pendências serão consultadas.
    #
    # === Retorno
    #
    # Retorna um Array de objetos Formulario pendentes.
    #
    # === Efeitos colaterais
    #
    # Consulta submissões, vínculos e formulários no banco de dados.
    def formularios_pendentes_para(user)
      formularios_respondidos_ids = Submissao.where(user: user).select(:formulario_id)
      mapa = papel_por_turma(user)

      Formulario
        .where(course_class_id: mapa.keys)
        .where.not(id: formularios_respondidos_ids)
        .select { |formulario| mapa[formulario.course_class_id] == formulario.target_role }
    end

    def papel_por_turma(user)
      user.class_memberships.each_with_object({}) { |m, h| h[m.course_class_id] = m.role }
    end

    def gerar_csv
      require "csv"
      CSV.generate(headers: true) do |csv|
        csv << cabecalho_csv
        @formulario.questaos.each { |q| csv << linha_csv(q) }
      end
    end

    def cabecalho_csv
      [ "ID da Pergunta", "Enunciado", "Tipo", "Respostas" ]
    end

    def linha_csv(questao)
      valores = questao.respostas.map { |r| helpers.formatar_resposta(r, questao.tipo) }
      [ questao.id, questao.enunciado, questao.tipo, valores.join("; ") ]
    end

    def render_create_success
      respond_to do |format|
        format.html { redirect_to formularios_path, notice: "Formulário gerado com sucesso!" }
        format.json { render :show, status: :created, location: @formulario }
      end
    end

    def render_create_failure
      @templates = current_admin.templates
      @course_classes = CourseClass.all
      respond_to do |format|
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @formulario.errors, status: :unprocessable_content }
      end
    end
end
