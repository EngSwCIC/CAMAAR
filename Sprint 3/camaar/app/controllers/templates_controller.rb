class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_template, only: %i[ show edit update destroy ]
  layout 'authenticated'

  # a. Descrição: Lista todos os templates cadastrados no sistema.
  # b. Argumentos: Não recebe argumentos diretos.
  # c. Retorno: Atribui uma coleção de todos os objetos Template à variável de instância @templates.
  # d. Efeitos colaterais: Renderiza a view de listagem (index). Não altera o banco de dados.
  def index
    @templates = Template.all
  end

  # a. Descrição: Carrega a view de exibição de um template específico.
  # b. Argumentos: Não recebe argumentos diretos (utiliza o before_action).
  # c. Retorno: Retorna implicitamente o objeto Template carregado em @template.
  # d. Efeitos colaterais: Renderiza a view 'show'. Não faz alterações no banco de dados.
  def show
  end

  # a. Descrição: Instancia um novo objeto Template vazio com uma questão associada em memória.
  # b. Argumentos: Não recebe argumentos diretos.
  # c. Retorno: Atribui a nova instância à variável @template.
  # d. Efeitos colaterais: Renderiza a view de formulário de criação (new). Não altera o banco de dados.
  def new
    @template = Template.new
    @template.questoes.build
  end

  # a. Descrição: Carrega a view de edição para um template já existente.
  # b. Argumentos: Não recebe argumentos diretos (utiliza o before_action).
  # c. Retorno: Retorna implicitamente o objeto Template carregado em @template.
  # d. Efeitos colaterais: Renderiza a view 'edit'. Não altera o banco de dados.
  def edit
  end

  # a. Descrição: Instancia e tenta persistir um novo template com base nos parâmetros submetidos.
  # b. Argumentos: Não recebe argumentos diretos (processa template_params do controller).
  # c. Retorno: Redireciona para a rota 'templates_path' em caso de sucesso, ou renderiza 'new' com status 422 em caso de falha.
  # d. Efeitos colaterais: Realiza transação de escrita (INSERT) no banco de dados se for válido e redireciona a página.
  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to templates_path, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # a. Descrição: Atualiza os dados de um template existente com os parâmetros submetidos.
  # b. Argumentos: Não recebe argumentos diretos (processa template_params).
  # c. Retorno: Redireciona para 'templates_path' em caso de sucesso, ou renderiza 'edit' com status 422 em caso de falha.
  # d. Efeitos colaterais: Realiza transação de atualização (UPDATE) no banco de dados e redireciona a página.
  def update
    if @template.update(template_params)
      redirect_to templates_path, notice: "Template atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # a. Descrição: Exclui um registro de template do sistema.
  # b. Argumentos: Não recebe argumentos diretos (utiliza o before_action).
  # c. Retorno: Redireciona para a lista de templates independentemente do sucesso, mas com mensagens (notice ou alert) distintas.
  # d. Efeitos colaterais: Realiza transação de exclusão (DELETE) no banco de dados e redireciona a página.
  def destroy
    if @template.destroy
      redirect_to templates_path, notice: "Template removido."
    else
      redirect_to templates_path, alert: @template.errors.full_messages.to_sentence
    end
  end

  private

  # a. Descrição: Busca e carrega um template específico baseado no parâmetro de rota :id.
  # b. Argumentos: Não recebe argumentos diretos (lê de params[:id]).
  # c. Retorno: Retorna a instância do Template correspondente e atribui a @template.
  # d. Efeitos colaterais: Levanta exceção ActiveRecord::RecordNotFound se o id não existir.
  def set_template
    @template = Template.find(params[:id])
  end

  # a. Descrição: Filtra os parâmetros da requisição aplicando as diretrizes de Strong Parameters.
  # b. Argumentos: Não recebe argumentos diretos.
  # c. Retorno: Retorna um objeto ActionController::Parameters apenas com :titulo e attributos aninhados de questoes.
  # d. Efeitos colaterais: Não possui efeitos colaterais.
  def template_params
    params.require(:template).permit(:titulo, questoes_attributes: [:id, :enunciado, :_destroy])
  end
end