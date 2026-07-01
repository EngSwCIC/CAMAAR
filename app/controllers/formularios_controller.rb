# frozen_string_literal: true

# Controller REST para listagem, criação em lote, visualização de relatório e
# exportação CSV de formulários.
#
# A autorização é feita via +FormularioPolicy+. A criação em lote delega a
# +Formularios::CreateFromTemplate+.
class FormulariosController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_formulario!, only: %i[show exportar_csv]
  before_action :set_formulario, only: %i[show exportar_csv]

  ##
  # Lista formulários do departamento e semestre atual do administrador logado.
  #
  # Argumentos:
  # - Nenhum parâmetro de request além da sessão autenticada.
  #
  # Retorno:
  # - Renderiza a view +index+ com +@user_formularios+ e +@other_formularios+.
  #
  # Efeitos colaterais:
  # - Consulta formulários filtrados por departamento, semestre e ordenação
  #   recente, separando os criados pelo usuário dos criados por outros.
  def index
    authorize! Formulario

    formularios = Formulario
      .do_departamento(current_administrador.departamento)
      .do_semestre_atual
      .recentes
      .includes(:template, :avaliacoes, turma: :materia)

    @user_formularios = formularios.criados_por(current_administrador)
    @other_formularios = formularios.criados_por_outros(current_administrador)
  end

  ##
  # Exibe o relatório de um formulário.
  #
  # Argumentos:
  # - +params[:id]+: id do formulário carregado em +@formulario+.
  #
  # Retorno:
  # - Renderiza a view +show+.
  #
  # Efeitos colaterais:
  # - Consulta o formulário via +set_formulario+ antes da action.
  def show
    authorize! @formulario
  end

  ##
  # Exibe o formulário de publicação de um template para turmas selecionadas.
  #
  # Argumentos:
  # - +params[:template_id]+ e +params[:materia_id]+ (opcionais): pré-seleção
  #   de template e matéria na interface.
  #
  # Retorno:
  # - Renderiza a view +new+ com templates, matérias e turmas do departamento.
  #
  # Efeitos colaterais:
  # - Consulta templates, matérias, turmas e professores disponíveis.
  def new
    @formulario = Formulario.new(adm: current_administrador)
    authorize! @formulario

    carregar_opcoes_de_selecao
  end

  ##
  # Publica formulários em lote a partir de um template e lista de turmas.
  #
  # Argumentos:
  # - +params[:template_id]+: template de origem.
  # - +params[:turma_ids]+: turmas que receberão o formulário.
  # - +params[:publico_alvo]+: público que deve responder (+docentes+ ou
  #   +discentes+).
  #
  # Retorno:
  # - Redireciona para +formularios_path+ com aviso de sucesso.
  # - Em falha, renderiza +new+ com status 422 e mensagem em +flash[:alert]+.
  #
  # Efeitos colaterais:
  # - Cria formulários, questões e avaliações via +Formularios::CreateFromTemplate+.
  # - Trata +Formularios::Error+, +ActiveRecord::RecordInvalid+ e
  #   +ActiveRecord::RecordNotFound+.
  def create
    authorize! Formulario.new(adm: current_administrador)

    criar_formularios_a_partir_do_template
    redirecionar_formulario_criado
  rescue Formularios::Error, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    renderizar_erro_criacao_formulario(e)
  end

  ##
  # Exporta respostas do formulário em CSV com separador +;+.
  #
  # Argumentos:
  # - +params[:id]+: id do formulário carregado em +@formulario+.
  #
  # Retorno:
  # - Envia arquivo CSV via +send_data+ com colunas de aluno, matrícula e
  #   resposta por questão.
  #
  # Efeitos colaterais:
  # - Consulta avaliações com respostas e gera o conteúdo do arquivo em memória.
  def exportar_csv
    authorize! @formulario
    export = Formularios::CSVExport.new(formulario: @formulario)

    send_data export.call,
      filename: export.filename,
      type: "text/csv; charset=utf-8"
  end

  private

  def criar_formularios_a_partir_do_template
    Formularios::CreateFromTemplate.call(
      template_id: params[:template_id],
      turma_ids: params[:turma_ids],
      publico_alvo: params[:publico_alvo],
      perfil_adm: current_administrador
    )
  end

  def redirecionar_formulario_criado
    redirect_to formularios_path,
      notice: "Formulário criado com sucesso para as turmas selecionadas"
  end

  def renderizar_erro_criacao_formulario(error)
    carregar_opcoes_de_selecao
    flash[:alert] = mensagem_erro_criacao_formulario(error)
    render :new, status: :unprocessable_content
  end

  def mensagem_erro_criacao_formulario(error)
    return "Template ou turma não encontrados" if error.is_a?(ActiveRecord::RecordNotFound)

    error.message
  end

  def carregar_opcoes_de_selecao
    templates = Template.includes(adm: :usuario).recentes

    @templates_proprios = templates.criados_por(current_administrador)
    @templates_outros = templates.criados_por_outros(current_administrador)
    @template_selecionado = params[:template_id].presence

    @materias = materias_do_departamento
    @materia_selecionada = params[:materia_id].presence

    @turmas = turmas_do_departamento
    @professores = professores_do_departamento
  end

  def materias_do_departamento
    Materia.do_departamento(current_administrador.departamento).order(:nome)
  end

  def turmas_do_departamento
    Turma
      .do_departamento(current_administrador.departamento)
      .do_semestre_atual
      .includes(:materia, participacoes_turma: :usuario)
      .order("materias.nome", :numero)
  end

  def professores_do_departamento
    current_administrador
      .departamento
      .docentes
      .order(:nome)
  end

  def set_formulario
    @formulario = Formulario
      .do_departamento(current_administrador.departamento)
      .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to formularios_path, alert: mensagem_formulario_indisponivel
  end

  def mensagem_formulario_indisponivel
    return "Você não tem permissão para exportar os resultados desse formulário." if action_name == "exportar_csv"

    "Você não tem permissão para acessar esse formulário."
  end

  def authorize_formulario!
    unless current_user&.administrador?
      redirect_to avaliacoes_pendentes_path, alert: "Apenas administradores possuem acesso a este recurso"
      return
    end

    authorize! Formulario
  end
end
