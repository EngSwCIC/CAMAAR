class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: %i[show edit update destroy]

  # GET /templates  (?q=termo para buscar — issue #1)
  def index
    @q = params[:q]
    @templates = Template.search(@q).order(:nome)
  end

  # GET /templates/:id
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
    @template.questions.build
  end

  # GET /templates/:id/edit
  def edit
  end

  # POST /templates
  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to @template, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /templates/:id
  def update
    if @template.update(template_params)
      redirect_to @template, notice: "Template atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /templates/:id
  def destroy
    @template.destroy
    redirect_to templates_path, notice: "Template removido com sucesso."
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(
      :nome, :descricao, :publico_alvo,
      questions_attributes: %i[id enunciado tipo opcoes _destroy]
    )
  end
end
