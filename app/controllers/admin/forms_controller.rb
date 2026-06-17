require "securerandom"

module Admin
  class FormsController < ApplicationController
    before_action :require_admin
    layout "gerenciamento"

    def index
      @workspace = workspace
      @forms = @workspace.forms
    end

    def new
      @workspace = workspace
      @form = blank_form
      @templates = @workspace.templates
    end

    def create
      @workspace = workspace
      @templates = @workspace.templates
      @form = form_payload
      @workspace.create_form(@form)
      flash[:notice] = "Formulário criado com sucesso"
      redirect_to admin_forms_path
    rescue ArgumentError => e
      flash.now[:alert] = e.message
      render :new, status: :unprocessable_entity
    end

    def publish
      form = workspace.find_form(params[:id])
      raise ActiveRecord::RecordNotFound, "Formulário não encontrado" unless form

      form["active"] = true
      workspace.persist!
      flash[:notice] = "Formulário enviado com sucesso"
      redirect_to admin_forms_path
    end

    def results
      @workspace = workspace
      @form = @workspace.find_form(params[:id])
      redirect_to admin_forms_path, alert: "Formulário não encontrado" unless @form
    end

    private

    def blank_form
      {
        "title" => "",
        "semester" => "2026.1",
        "professor" => "Professor",
        "template_id" => @workspace.templates.first&.dig("id"),
        "audience" => "aluno",
        "recipients" => []
      }
    end

    def form_payload
      payload = params.require(:form).permit(:title, :semester, :professor, :template_id, :audience, recipients: [])

      {
        "title" => payload[:title].to_s.strip,
        "semester" => payload[:semester].to_s.strip,
        "professor" => payload[:professor].to_s.strip,
        "template_id" => payload[:template_id].to_s,
        "audience" => payload[:audience].to_s,
        "recipients" => Array(payload[:recipients]).map(&:to_s)
      }
    end
  end
end
