##
# Gerencia templates de avaliação e suas questões para o administrador autenticado.
class TemplatesController < ApplicationController
  before_action :require_admin!
  before_action :set_template, only: %i[ show edit update destroy ]
  before_action :authorize_template_access!, only: %i[ show edit update destroy ]

  ##
  # Lista os templates pertencentes ao administrador atual.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML ou JSON construída pelo Rails.
  #
  # Efeitos colaterais: consulta o banco e define +@templates+ para a view.
  def index
    @templates = current_admin.templates
  end

  ##
  # Exibe os detalhes do template carregado.
  #
  # Não recebe argumentos explícitos; utiliza +params[:id]+ por meio dos callbacks.
  #
  # Retorna a resposta HTML ou JSON construída pelo Rails.
  #
  # Efeitos colaterais: utiliza o template consultado e autorizado pelos callbacks.
  def show
  end

  ##
  # Prepara o formulário de criação de template.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML construída pelo Rails.
  #
  # Efeitos colaterais: instancia +@template+ e inicializa +@questoes_attrs+.
  def new
    @template = Template.new
    @questoes_attrs = []
  end

  ##
  # Prepara a edição do template e de suas questões existentes.
  #
  # Não recebe argumentos explícitos; utiliza o template carregado pelo callback.
  #
  # Retorna a resposta HTML construída pelo Rails.
  #
  # Efeitos colaterais: consulta questões e define +@questoes_attrs+ para a view.
  def edit
    @questoes_attrs = @template.questaos.map do |questao|
      { id: questao.id, enunciado: questao.enunciado, tipo: questao.tipo }
    end
  end

  ##
  # Cria um template e suas questões ou adiciona um campo vazio ao formulário.
  #
  # Não recebe argumentos explícitos; utiliza os parâmetros da requisição.
  #
  # Retorna um redirecionamento quando persiste o template ou uma resposta HTML
  # com o formulário e o status adequado.
  #
  # Efeitos colaterais: pode persistir template e questões em transação, acrescentar
  # atributos em memória ou renderizar mensagens de validação.
  def create
    @template = Template.new(template_params)
    @questoes_attrs = extract_questoes_attrs

    if params[:add_questao]
      @questoes_attrs << blank_questao_attrs
      return render :new, status: :ok
    end

    return render :new, status: :unprocessable_content unless @template.valid? && questoes_attrs_valid?

    salvar_novo_template
    redirect_to templates_path, notice: "Template criado com sucesso."
  end

  ##
  # Atualiza o template e suas questões ou adiciona um campo vazio ao formulário.
  #
  # Não recebe argumentos explícitos; utiliza o template carregado e os parâmetros da requisição.
  #
  # Retorna um redirecionamento quando atualiza os dados ou uma resposta HTML com erros.
  #
  # Efeitos colaterais: altera template e questões em transação, pode criar novas questões
  # e define mensagens de sucesso ou validação.
  def update
    @template.assign_attributes(template_params)
    @questoes_attrs = extract_questoes_attrs

    if params[:add_questao]
      @questoes_attrs << blank_questao_attrs
      return render :edit, status: :ok
    end

    processar_atualizacao_template
  end

  ##
  # Exclui o template carregado.
  #
  # Não recebe argumentos explícitos; utiliza o template carregado pelo callback.
  #
  # Retorna uma resposta de redirecionamento com status +303 See Other+.
  #
  # Efeitos colaterais: remove o template e suas questões, desvincula formulários
  # existentes e define uma mensagem de sucesso.
  def destroy
    @template.destroy!
    redirect_to templates_path, notice: "Template deletado com sucesso.", status: :see_other
  end

  private
    ##
    # Carrega o template indicado na rota.
    #
    # Não recebe argumentos explícitos; utiliza +params[:id]+.
    #
    # Retorna o Template encontrado.
    #
    # Efeitos colaterais: consulta o banco, define +@template+ e pode lançar
    # ActiveRecord::RecordNotFound.
    def set_template
      @template = Template.find(params.expect(:id))
    end

    ##
    # Verifica se o template pertence ao administrador atual.
    #
    # Não recebe argumentos explícitos; utiliza +@template+ e +current_admin+.
    #
    # Retorna +nil+ quando autorizado ou o resultado do redirecionamento quando negado.
    #
    # Efeitos colaterais: pode redirecionar para a listagem e definir uma mensagem de alerta.
    def authorize_template_access!
      redirect_to templates_path, alert: "Você não tem acesso a esse template" unless @template.admin_id == current_admin.id
    end

    ##
    # Filtra os atributos do template e associa o administrador atual.
    #
    # Não recebe argumentos explícitos; lê +params[:template]+.
    #
    # Retorna ActionController::Parameters com +title+, +target_role+ e +admin_id+.
    #
    # Efeitos colaterais: acrescenta o identificador do administrador aos parâmetros e
    # pode lançar ActionController::ParameterMissing.
    def template_params
      attrs = params.expect(template: [ :title, :target_role ])
      attrs[:admin_id] = current_admin.id
      attrs
    end

    ##
    # Normaliza os atributos de questões enviados pelo formulário.
    #
    # Não recebe argumentos explícitos; lê +params[:template][:questaos]+.
    #
    # Retorna um Array de hashes com +id+, +enunciado+ e +tipo+, ou um Array vazio
    # quando nenhuma questão foi enviada.
    #
    # Efeitos colaterais: não possui efeitos colaterais.
    def extract_questoes_attrs
      raw = params.dig(:template, :questaos)
      return [] unless raw

      raw.values.map do |questao|
        attrs = { enunciado: questao[:enunciado].to_s, tipo: questao[:tipo].presence || "rating" }
        attrs[:id] = questao[:id] if questao[:id].present?
        attrs
      end
    end

    ##
    # Constrói os atributos iniciais de uma nova questão vazia.
    #
    # Não recebe argumentos.
    #
    # Retorna um Hash com enunciado vazio e tipo +rating+.
    #
    # Efeitos colaterais: não possui efeitos colaterais.
    def blank_questao_attrs
      { enunciado: "", tipo: "rating" }
    end

    ##
    # Valida se todas as questões informadas possuem enunciado.
    #
    # Não recebe argumentos explícitos; utiliza +@questoes_attrs+ e +@template+.
    #
    # Retorna +true+ quando todos os enunciados estão preenchidos e +false+ caso contrário.
    #
    # Efeitos colaterais: adiciona uma mensagem à coleção de erros do template quando inválido.
    def questoes_attrs_valid?
      if @questoes_attrs.any? { |questao| questao[:enunciado].blank? }
        @template.errors.add(:base, "Questão não possui enunciado")
        false
      else
        true
      end
    end

    ##
    # Valida se as novas questões de uma edição possuem enunciado.
    #
    # === Argumentos
    #
    # +novas_questoes+:: Array de hashes que representam apenas as questões ainda não persistidas.
    #
    # === Retorno
    #
    # Retorna +true+ quando os enunciados estão preenchidos e +false+ caso contrário.
    #
    # === Efeitos colaterais
    #
    # Adiciona uma mensagem à coleção de erros do template quando houver campo vazio.
    def novas_questoes_validas?(novas_questoes)
      if novas_questoes.any? { |questao| questao[:enunciado].blank? }
        @template.errors.add(:base, "A nova questão não possui enunciado")
        false
      else
        true
      end
    end

    def processar_atualizacao_template
      novas_questoes = @questoes_attrs.reject { |questao| questao[:id].present? }
      return render :edit, status: :unprocessable_content unless @template.valid? && novas_questoes_validas?(novas_questoes)

      atualizar_template
      redirect_to templates_path, notice: "Template atualizado com sucesso."
    end

    def salvar_novo_template
      Template.transaction do
        @template.save!
        @questoes_attrs.each { |q| @template.questaos.create!(enunciado: q[:enunciado], tipo: q[:tipo]) }
      end
    end

    def atualizar_template
      Template.transaction do
        @template.save!
        @questoes_attrs.each { |q| persistir_questao(q) }
      end
    end

    def persistir_questao(questao)
      if questao[:id].present?
        @template.questaos.find(questao[:id]).update!(enunciado: questao[:enunciado], tipo: questao[:tipo])
      else
        @template.questaos.create!(enunciado: questao[:enunciado], tipo: questao[:tipo])
      end
    end
end
