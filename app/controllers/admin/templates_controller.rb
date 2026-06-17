class Admin::TemplatesController < Admin::BaseController
  def index
    @templates = Template.all
  end

  def new
    @template = Template.new
    @template.template_questoes.build
  end

  def create
    @template = current_pessoa.templates.build(template_params)
    if @template.save
      redirect_to admin_templates_path, notice: 'Template criado com sucesso.'
    else
      @template.template_questoes.build if @template.template_questoes.empty?
      flash.now[:alert] = 'O nome do template é obrigatório.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @template = Template.find(params[:id])
    @template.template_questoes.build if @template.template_questoes.empty?
  end

  def update
    @template = Template.find(params[:id])
    if @template.update(template_params)
      redirect_to admin_templates_path, notice: 'Template atualizado com sucesso.'
    else
      @template.template_questoes.build if @template.template_questoes.empty?
      flash.now[:alert] = 'O nome do template é obrigatório. Erro apontando os campos que precisam ser corrigidos.'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def template_params
    params.require(:template).permit(:nome, template_questoes_attributes: [:id, :enunciado, :tipo_resposta, :opcoes, :_destroy])
  end
end