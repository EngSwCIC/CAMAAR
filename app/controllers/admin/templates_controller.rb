##
# Controller para gerenciamento de templates pelos administradores
#
# Permite que administradores criem, editem, visualizem e excluam templates
# de avaliação. Também fornece acesso às respostas coletadas.
#
# === Autenticação e Autorização
# * Requer login ativo (before_action :require_login)
# * Requer permissões de admin (before_action :require_admin)
# * Apenas templates do próprio admin são acessíveis
#
# === Funcionalidades Principais
# * Listagem de templates criados pelo admin
# * Criação de novos templates com perguntas
# * Edição de templates existentes
# * Visualização de detalhes e respostas
# * Exclusão de templates
#
# === Rotas
#   GET    /admin/templates          # index
#   GET    /admin/templates/new      # new
#   POST   /admin/templates          # create
#   GET    /admin/templates/:id      # show
#   GET    /admin/templates/:id/edit # edit
#   PATCH  /admin/templates/:id      # update
#   DELETE /admin/templates/:id      # destroy
#
class Admin::TemplatesController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_template, only: [ :show, :edit, :update, :destroy ]

  ##
  # Lista todos os templates criados pelo admin atual
  #
  # === Variáveis de instância
  # +@templates+:: Collection de templates ordenados por nome
  #
  # === Template
  # Renderiza grid de cards com informações básicas e ações para cada template
  def index
    @templates = current_user.templates.order(:name)
  end

  ##
  # Exibe detalhes de um template específico
  #
  # Mostra informações do template, suas perguntas e respostas recebidas.
  # Inclui funcionalidade para expandir detalhes das respostas individuais.
  #
  # === Variáveis de instância
  # +@template+:: Template sendo visualizado
  # +@responses+:: Respostas recebidas com dados do usuário pré-carregados
  #
  # === Segurança
  # Apenas templates do admin atual podem ser visualizados
  def show
    @responses = @template.template_responses.includes(:user)
  end

  ##
  # Exibe formulário para criação de novo template
  #
  # Inicializa template vazio com uma pergunta padrão para facilitar UX.
  #
  # === Variáveis de instância
  # +@template+:: Novo template associado ao admin atual
  #
  # === Features do Formulário
  # * Campos para nome e descrição do template
  # * Seção dinâmica para adicionar/remover perguntas
  # * Validação client-side básica
  def new
    @template = current_user.templates.build
    @template.template_questions.build
  end

  ##
  # Processa criação de novo template
  #
  # Salva template com perguntas aninhadas usando accepts_nested_attributes_for.
  # Em caso de sucesso, redireciona para listagem. Em caso de erro, re-renderiza formulário.
  #
  # === Parâmetros
  # Utiliza template_params para strong parameters com nested attributes
  #
  # === Responses
  # * Sucesso: Redirect para admin_templates_path com notice
  # * Falha: Render :new com status 422 e erros de validação
  def create
    @template = current_user.templates.build(template_params)

    if @template.save
      redirect_to admin_templates_path, notice: "Template criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  ##
  # Exibe formulário para edição de template existente
  #
  # Permite modificar nome, descrição e perguntas do template.
  # Suporta adição, edição e remoção de perguntas existentes.
  #
  # === Variáveis de instância
  # +@template+:: Template carregado via set_template
  #
  # === Funcionalidades
  # * Edição inline de perguntas existentes
  # * Adição dinâmica de novas perguntas
  # * Marcação para exclusão de perguntas
  def edit
  end

  ##
  # Processa atualização de template existente
  #
  # Atualiza template e perguntas associadas usando nested attributes.
  # Suporta criação, edição e exclusão de perguntas numa única operação.
  #
  # === Responses
  # * Sucesso: Redirect para admin_templates_path com notice
  # * Falha: Render :edit com status 422 e erros
  def update
    if @template.update(template_params)
      redirect_to admin_templates_path, notice: "Template atualizado!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  ##
  # Remove template permanentemente
  #
  # Exclui template e todas as associações (perguntas, respostas).
  # Operação irreversível com confirmação via JavaScript.
  #
  # === Efeitos Cascata
  # * TemplateQuestion records são removidos (dependent: :destroy)
  # * TemplateResponse records são removidos (dependent: :destroy)
  # * QuestionAnswer records são removidos via template_responses
  def destroy
    @template.destroy
    redirect_to admin_templates_path, notice: "Template removido!"
  end

  private

  ##
  # Carrega template específico do admin atual
  #
  # Usado pelos before_actions para ações que operam em template específico.
  # Garante que apenas templates do admin atual sejam acessíveis.
  #
  # === Segurança
  # Scope automático via current_user.templates previne acesso não autorizado
  def set_template
    @template = current_user.templates.find(params[:id])
  end

  ##
  # Strong parameters para template e perguntas aninhadas
  #
  # === Parâmetros Permitidos
  # * Template: name, description
  # * Perguntas: id, question_text, question_type, required, position, _destroy
  # * Options: array para futuras opções de múltipla escolha
  #
  # === Retorno
  # +ActionController::Parameters+:: Parâmetros filtrados e seguros
  def template_params
    params.require(:template).permit(:name, :description,
      template_questions_attributes: [ :id, :question_text, :question_type, :required, :position, :_destroy, options: [] ])
  end

  ##
  # Verifica se usuário atual é administrador
  #
  # Redireciona usuários não-admin para área de usuário comum.
  # Used as before_action para proteger todas as ações do controller.
  def require_admin
    redirect_to user_templates_path unless current_user.admin?
  end
end
