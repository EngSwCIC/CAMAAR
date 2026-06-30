##
# Define a controller para gerenciar templates de formulários, incluindo criação, edição, listagem e exclusão.
class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: %i[show edit update destroy]

  ##
  # a. Descrição: Lista todos os templates de formulários, com opção de busca por nome.
  # b. Argumentos: Recebe 'q' (String) como parâmetro de busca.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Atribui as variáveis de instância @q e @templates.
  def index
    @q = params[:q]
    @templates = Template.search(@q).order(:nome)
  end

  ##
  # a. Descrição: Mostra os detalhes de um template de formulário específico.
  # b. Argumentos: Recebe 'id' (Integer) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Atribui a variável de instância @template.
  def show
  end

  ##
  # a. Descrição: Instancia um novo template de formulário.
  # b. Argumentos: Nenhum.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Atribui a variável de instância @template.
  def new
    @template = Template.new
  end

  ##
  # a. Descrição: Prepara os dados necessários para editar um template de formulário existente.
  # b. Argumentos: Recebe 'id' (Integer) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Atualiza a variável de instância @template com mudanças.
  def edit
  end

  ##
  # a. Descrição: Cria um novo template de formulário com os parâmetros fornecidos.
  # b. Argumentos: Recebe 'template_params' (Hash) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Salva o template no banco de dados e redireciona para a página de exibição do template criado, ou renderiza a página de criação com erros.
  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to @template, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  ##
  # a. Descrição: Atualiza um template de formulário existente com os parâmetros fornecidos.
  # b. Argumentos: Recebe 'template_params' (Hash) como parâmetro
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Atualiza o template no banco de dados e redireciona para a página de exibição do template atualizado, ou renderiza a página de edição com erros.
  def update
    if @template.update(template_params)
      redirect_to @template, notice: "Template atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  ##
  # a. Descrição: Exclui um template de formulário existente, se a confirmação for fornecida.
  # b. Argumentos: Recebe 'confirmar' (String) como parâmetro de confirmação.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Remove o template do banco de dados e redireciona para a lista de templates, ou mantém o template se a confirmação não for fornecida.
  def destroy
    # Só exclui quando a caixa de confirmação foi marcada (cancelar mantém).
    unless params[:confirmar].present?
      redirect_to templates_path and return
    end

    @template.destroy
    redirect_to templates_path, notice: "Template removido com sucesso."
  end

  private

  # Busca o template pelo ID fornecido nos parâmetros da requisição.
  def set_template
    @template = Template.find(params[:id])
  end

  # Permite apenas os parâmetros necessários para criar/atualizar um template, incluindo atributos aninhados para perguntas.
  def template_params
    params.require(:template).permit(
      :nome, :descricao, :publico_alvo,
      questions_attributes: %i[id enunciado tipo opcoes _destroy]
    )
  end
end
