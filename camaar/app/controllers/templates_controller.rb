class TemplatesController < ApplicationController
  def show
    @template = Template.find(params[:id])
  end
  def index
    @templates = Template.all
  end
  def new
    @template = Template.new
  end
  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to templates_path, notice: "#{@template.title} created."
    else
      flash[:alert] = "Template could not be created: " + @template.errors.full_messages.join(", ")
      render 'new'
    end
  end
  def edit
    @template = Template.find params[:id]
  end
  def update
    @template = Template.find params[:id]
    if (@template.update_attributes(template_params))
      redirect_to template_path(@template), :notice => "#{@template.title} updated."
    else
      flash[:alert] = "#{@template.title} could not be updated: " +
        @template.errors.full_messages.join(",")
      render 'edit'
    end
  end
  def destroy
    @template = Template.find(params[:id])
    @template.destroy
    redirect_to templates_path, :notice => "#{@template.title} deleted."
  end
  private
  def template_params
    params.require(:template)
    params[:template].permit(:title,:rating,:release_date)
  end
end
