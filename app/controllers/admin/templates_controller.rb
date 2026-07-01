# Controller para CRUD de templates de formulário no painel admin
class Admin::TemplatesController < ApplicationController
  before_action :require_admin
  layout "dashboard"
  before_action :set_template, only: [:update, :destroy]

  # Lista todos os templates
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum (renderiza view)
  # Efeitos colaterais: Nenhum
  def index
    @templates = Template.order(:nome)
  end

  # Cria um novo template com suas questões
  #
  # Argumentos: params[:template] — nome; params[:questions] — array de questões
  # Retorno: Nenhum (redireciona)
  # Efeitos colaterais: Cria registros de Template e Question no banco
  def create
    name = extract_template_name
    return redirect_to(admin_templates_path, alert: "O nome do template é obrigatório") if name.blank?

    @template = Template.new(nome: name, semester: template_semester)
    persist_template("Template criado com sucesso")
  end

  # Atualiza um template existente
  #
  # Argumentos: params[:id], params[:template]
  # Retorno: Nenhum (redireciona)
  # Efeitos colaterais: Atualiza registro no banco
  def update
    ActiveRecord::Base.transaction do
      if @template.update(nome: resolve_nome, semester: template_semester)
        build_questions(@template, replace: true)
        flash[:notice] = "Template atualizado com sucesso"
      else
        flash[:alert] = @template.errors.full_messages.join(", ")
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.record.errors.full_messages.join(", ")
  ensure
    redirect_to admin_templates_path
  end

  # Exclui um template
  #
  # Argumentos: params[:id]
  # Retorno: Nenhum (redireciona)
  # Efeitos colaterais: Remove o template do banco
  def destroy
    @template.destroy
    redirect_to admin_templates_path, notice: "Template removido com sucesso"
  end

  private

  def set_template
    @template = Template.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_templates_path, alert: "Template não encontrado"
  end

  # Extrai o nome do template dos params (suporta :name e :nome)
  #
  # Argumentos: Nenhum
  # Retorno: String ou nil
  # Efeitos colaterais: Nenhum
  def extract_template_name
    params.dig(:template, :name).presence || params.dig(:template, :nome)
  end

  # Extrai o semestre do template dos params
  #
  # Argumentos: Nenhum
  # Retorno: String ou nil
  # Efeitos colaterais: Nenhum
  def template_semester
    params.dig(:template, :semester)
  end

  # Resolve o nome a usar no update (prioridade: name > nome > nome atual)
  #
  # Argumentos: Nenhum
  # Retorno: String
  # Efeitos colaterais: Nenhum
  def resolve_nome
    extract_template_name.presence || @template.nome
  end

  # Salva o template e redireciona com mensagem de sucesso ou erro
  #
  # Argumentos: success_msg (String)
  # Retorno: ActionDispatch::Response (redirect)
  # Efeitos colaterais: Persiste Template e Questions no banco
  def persist_template(success_msg)
    ActiveRecord::Base.transaction do
      if @template.save
        build_questions(@template)
        flash[:notice] = success_msg
      else
        flash[:alert] = @template.errors.full_messages.join(", ")
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.record.errors.full_messages.join(", ")
  ensure
    redirect_to admin_templates_path
  end

  # Constrói questões a partir dos params
  #
  # Argumentos: template (Template), replace (Boolean)
  # Retorno: Nenhum
  # Efeitos colaterais: Cria/deleta registros de Question
  def build_questions(template, replace: false)
    return unless params[:questions].present?
    template.questions.destroy_all if replace
    params[:questions].each_value { |q| persist_question(template, q) }
  end

  # Persiste uma questão individual se o texto não for vazio
  #
  # Argumentos: template (Template), q (Hash com :text e :kind)
  # Retorno: Nenhum
  # Efeitos colaterais: Cria registro de Question no banco
  def persist_question(template, q)
    return if q[:text].blank?
    template.questions.create!(
      kind: q[:kind].presence || "text",
      text: q[:text],
      options: extract_options(q)
    )
  end

  # Filtra opções em branco enviadas para uma questão
  #
  # Argumentos: q (Hash com possível chave :options)
  # Retorno: Array de String
  # Efeitos colaterais: Nenhum
  def extract_options(q)
    Array(q[:options]).map(&:to_s).map(&:strip).reject(&:blank?)
  end
end
