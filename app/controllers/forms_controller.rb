require "securerandom"

class FormsController < ApplicationController
  def index
    @workspace = workspace
    @forms = @workspace.pending_forms
  end

  def show
    @workspace = workspace
    @form = @workspace.find_form(params[:id])
    redirect_to forms_path, alert: "Formulário não encontrado" unless @form
  end

  def create_response
    @workspace = workspace
    @form = @workspace.find_form(params[:id])
    raise ActiveRecord::RecordNotFound, "Formulário não encontrado" unless @form

    @workspace.record_response(@form["id"], response_payload)
    flash[:notice] = "Avaliação enviada com sucesso"
    redirect_to forms_path
  rescue ArgumentError => e
    flash.now[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  private

  def response_payload
    payload = params.require(:response).permit(:comment, answers: {})
    {
      "comment" => payload[:comment].to_s.strip,
      "answers" => payload[:answers].to_h.transform_values { |value| value.to_s }
    }
  end
end
