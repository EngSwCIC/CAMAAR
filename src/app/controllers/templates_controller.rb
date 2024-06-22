class TemplatesController < ApplicationController
  before_action :set_template, only: %i[ show edit update destroy ]

  def index
    if current_user
      @templates = current_user.templates
      Rails.logger.debug @templates.inspect
    else
      redirect_to new_user_session_path, alert: "Você precisa estar logado para acessar esta página."
    end
  end

  def show
    @template = Template.find_by(id: params[:id])
  end

  def edit
  end

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

    if @template.questoes.any? && @template.save
      redirect_to templates_url, notice: "Template was successfully created.", status: 302
    elsif !@template.questoes.any?
      render :new, notice: "Você deve adicionar alguma questão ao template antes de criá-lo.", status: 400
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @template.update(template_params)
      redirect_to template_url, notice: "Template atualizado!"
    else
      render template_url(@template), status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy!

    redirect_to templates_url, notice: "Template excluído com sucesso."
  end

  private
    def set_template
      @template = Template.find_by(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def template_params
      params.require(:template).permit(:user, :semestre, :nome, :questoes)
    end
end
