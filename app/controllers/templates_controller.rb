# Controller para gerenciar o ciclo de vida dos templates de formulários
class TemplatesController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # Lista e pagina os templates, permitindo busca por nome
  #
  # Argumentos: Nenhum (usa params: :page, :q, :simulate_error)
  # Retorno: Renderiza a view index
  # Efeitos Colaterais: Altera variáveis de instância de paginação e filtros; pode lançar erro simulado.
  def index
    @templates = Template.order(:nome)

    if params[:simulate_error] == "true"
      raise StandardError, "Falha simulada no servidor"
    end

    if params[:q].present?
      if ActiveRecord::Base.connection.adapter_name.downcase.include?("sqlite")
        @templates = @templates.where(
          "lower(nome) LIKE ?",
          "%#{params[:q].downcase}%"
        )
      else
        @templates = @templates.where(
          "nome ILIKE ?",
          "%#{params[:q]}%"
        )
      end
    end

    per_page = 5
    page = params[:page].to_i
    page = 1 if page < 1

    @has_previous_page = page > 1
    @has_next_page = @templates.offset(page * per_page).limit(1).exists?
    @current_page = page
    @templates = @templates.offset((page - 1) * per_page).limit(per_page)
  rescue StandardError
    flash.now[:alert] = "Erro ao carregar a lista de templates"
    @templates = Template.none
    @has_previous_page = false
    @has_next_page = false
    @current_page = 1
  end

  # Exibe os detalhes de um template específico
  #
  # Argumentos: Nenhum (usa @template definido no set_template)
  # Retorno: Renderiza a view show
  # Efeitos Colaterais: Nenhum
  def show
  end

  # Exibe o formulário de edição do template
  #
  # Argumentos: Nenhum (usa @template definido no set_template)
  # Retorno: Renderiza a view edit
  # Efeitos Colaterais: Nenhum
  def edit
  end

  # Cria uma nova versão do template a partir das alterações enviadas
  #
  # Argumentos: Nenhum (usa params via template_params e @template)
  # Retorno: Redirecionamento HTTP
  # Efeitos Colaterais: Duplica o registro atual, incrementa a versão e salva no banco de dados.
  def update
    # Cria uma nova versão do template em vez de alterar o original
    novo = @template.dup

    if novo.respond_to?(:parent_template=)
      novo.parent_template = @template
    end

    novo.user = current_user if novo.respond_to?(:user=)
    novo.version = @template.version + 1 if novo.respond_to?(:version=)

    if novo.update(template_params)
      redirect_to templates_path,
                  notice: "Nova versão do template criada com sucesso."
    else
      flash[:alert] = novo.errors.full_messages.to_sentence
      redirect_to edit_template_path(@template)
    end
  end

  # Remove o template se ele não estiver associado a nenhum formulário
  #
  # Argumentos: Nenhum (usa @template definido no set_template)
  # Retorno: Redirecionamento HTTP
  # Efeitos Colaterais: Exclui o registro do template no banco de dados ou exibe alerta de erro.
  def destroy
    if @template.forms.exists?
      redirect_to templates_path,
                  alert: "Template está em uso por formulários"
      return
    end

    if @template.destroy
      redirect_to templates_path,
                  notice: "Template removido com sucesso."
    else
      redirect_to templates_path,
                  alert: @template.errors.full_messages.to_sentence
    end
  end

  private

  # Define o template alvo das ações baseado no ID
  #
  # Argumentos: Nenhum (usa params[:id])
  # Retorno: Objeto Template ou Redirecionamento se não encontrado
  # Efeitos Colaterais: Define a variável de instância @template ou redireciona com flash de erro.
  def set_template
    @template = Template.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to templates_path,
                alert: "Template não encontrado."
  end

  # Filtra os parâmetros permitidos para o template
  #
  # Argumentos: Nenhum (usa params)
  # Retorno: ActionController::Parameters (strong params permitidos)
  # Efeitos Colaterais: Nenhum
  def template_params
    params.require(:template)
          .permit(:nome, :descricao)
  end

  # Garante que o usuário esteja logado no sistema
  #
  # Argumentos: Nenhum (usa current_user)
  # Retorno: Redirecionamento se não logado
  # Efeitos Colaterais: Interrompe o fluxo da requisição se o usuário for nulo.
  def require_login
    redirect_to login_path unless current_user
  end

  # Garante que o usuário logado possui privilégios de administrador
  #
  # Argumentos: Nenhum (usa current_user)
  # Retorno: Redirecionamento se não for admin
  # Efeitos Colaterais: Interrompe o fluxo da requisição se o usuário não for admin.
  def require_admin
    unless current_user&.admin?
      redirect_to root_path,
                  alert: "Acesso negado."
    end
  end
end