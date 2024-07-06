# Controlador para gerenciar as ações relacionadas aos Templates
class TemplatesController < ApplicationController
  before_action :set_template, only: %i[ show edit update destroy ]

  ##
  # Exibe a lista de todos os templates do usuário atual
  #
  # +effect_side+ Redireciona para a página de login se o usuário não estiver logado, caso contrário, renderiza a página index com a lista de templates
  def index
    if current_user
      @templates = current_user.templates
      render status: :ok
    else
      redirect_to new_user_session_path, alert: "Você precisa estar logado para acessar esta página."
    end
  end

  ##
  # Exibe um template específico
  #
  # +param+ [Integer] id - O ID do template a ser exibido, obtido dos parâmetros
  def show
    @template = Template.find_by(id: params[:id])
  end

  ##
  # Exibe o formulário para editar um template existente
  #
  # +param+ [Integer] id - O ID do template a ser editado, obtido dos parâmetros
  def edit
  end

  ##
  # Cria um novo template
  #
  # +param+ [Hash] template - Os parâmetros do template a ser criado, obtido dos parâmetros permitidos
  # +effect_side+ Cria um novo registro de template no banco de dados. Redireciona para a página index se bem-sucedido, ou renderiza a página new se houver erros
  def create  
    # recupera os elementos passados pela rota  
    template = params[:template]

    user = User.find_by(template['user_id'])
    semestre = template['semestre']
    nome = template['nome']
    questoes = []

    if !template['questoes_id'].nil?
      template['questoes_id'].each do |questao_id|
        questoes << Questao.find_by(questao_id)
      end
    end

    @template = Template.new(user: user, semestre: semestre, nome: nome, questoes: questoes)

    if @template.save
      redirect_to templates_url, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  ##
  # Atualiza um template existente
  #
  # +param+ [Hash] template_params - Os parâmetros do template a ser atualizado, obtido dos parâmetros permitidos
  # +param+ [Integer] id - O ID do template a ser atualizado, obtido dos parâmetros
  # +effect_side+ Atualiza um registro de template no banco de dados. Redireciona para a página show se bem-sucedido, ou renderiza a página edit se houver erros
  def update
    if @template.update(template_params)
      redirect_to template_url, notice: "Template atualizado!"
    else
      render template_url(@template), status: :unprocessable_entity
    end
  end

  ##
  # Exclui um template existente
  #
  # +param+ [Integer] id - O ID do template a ser excluído, obtido dos parâmetros
  # +effect_side+ Remove um registro de template do banco de dados. Redireciona para a página index após exclusão
  def destroy
    @template.destroy!

    redirect_to templates_url, notice: "Template excluído com sucesso."
  end

  private
    def set_template
      @template = Template.find_by(params[:id])
    end

    def template_params
      params.require(:template).permit(:user_id, :semestre, :nome, questoes_ids: [])
    end
end
