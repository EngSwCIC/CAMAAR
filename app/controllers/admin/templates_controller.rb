require "securerandom"

module Admin
  class TemplatesController < ApplicationController
    before_action :require_admin
    layout "gerenciamento"

    def index
      @workspace = workspace
      @templates = @workspace.templates
    end

    def new
      @workspace = workspace
      @template = blank_template
    end

    def create
      @workspace = workspace
      @template = template_payload
      @template = @workspace.create_template(@template)
      flash[:notice] = "Template criado com sucesso!"
      redirect_to admin_templates_path
    rescue ArgumentError => e
      flash.now[:alert] = e.message
      render :new, status: :unprocessable_entity
    end

    def edit
      @workspace = workspace
      @template = @workspace.find_template(params[:id])
      redirect_to admin_templates_path, alert: "Template não encontrado" unless @template
    end

    def update
      @workspace = workspace
      @template = @workspace.update_template(params[:id], template_payload)
      flash[:notice] = "Template atualizado com sucesso!"
      redirect_to admin_templates_path
    rescue ArgumentError => e
      flash.now[:alert] = e.message
      @template = @workspace.find_template(params[:id]) || blank_template
      render :edit, status: :unprocessable_entity
    end

    def destroy
      workspace.delete_template(params[:id])
      flash[:notice] = "Template deletado com sucesso!"
      redirect_to admin_templates_path
    end

    private

    def blank_template
      {
        "id" => nil,
        "title" => "",
        "semester" => "2026.1",
        "questions" => [
          { "id" => SecureRandom.uuid, "title" => "Questão 1", "type" => "radio", "options" => [ "Ótimo", "Bom", "Regular", "Ruim" ] }
        ]
      }
    end

    def template_payload
      payload = params.require(:template).permit(:title, :semester, questions: {})
      questions = payload[:questions].to_h.values.map do |question|
        options = question[:options].to_s.split(",").map(&:strip).reject(&:blank?)

        {
          "id" => question[:id].presence || SecureRandom.uuid,
          "title" => question[:title].to_s.strip,
          "type" => question[:type].to_s,
          "options" => options
        }
      end

      {
        "title" => payload[:title].to_s.strip,
        "semester" => payload[:semester].to_s.strip,
        "questions" => questions
      }
    end
  end
end
