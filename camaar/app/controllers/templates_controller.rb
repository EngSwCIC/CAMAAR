class TemplatesController < ApplicationController
  def index
    @templates = Template.all
  end

  def show
    @template = Template.find(params[:id])
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to @template
    else
      flash[:alert] = "Infelizmente houve um erro na criação de seu template"
      render 'new'
    end
  end

  def edit
    @template = Template.find(params[:id])
  end

  def update
    @template = Template.find(params[:id])
    if @template.update(template_params)
      redirect_to @template
    else
      render 'edit'
    end
  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy
    redirect_to templates_path
  end

  private

  def template_params
    params.require(:template).permit(:numeroDeAlternativas, :discursiva?, :nome, :fatorDeCorreção?)
  end
end
