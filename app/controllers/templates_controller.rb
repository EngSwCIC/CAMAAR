# frozen_string_literal: true

# Controls routes for templates. Only administrators may see or edit templates.
class TemplatesController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  # TODO: add authentication with `return unless user_authenticated && admin_user?`

  def index
    @templates = Template.all
  end

  def show
    @template = Template.find(params[:id])
  end

  def create
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end

  def update
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end

  # GET: Page for sending a form to students of a discipline
  def edit_send
    return redirect_to root_path unless user_authenticated && admin_user?

    @disciplines = Discipline.all
    @templates = Template.all
    render 'templates/send/index'
  end

  # FIXME: Move this route to /templates instead of /templates/:id so that we don't get the template id twice
  # POST: Gives students of disciplines access to a form copied from the given template
  def send_out_forms
    return redirect_to root_path unless user_authenticated && admin_user?

    params.permit(:authenticity_token, :commit, :id, :template_id, discipline_ids: [])

    if params[:discipline_ids].nil?
      flash[:error] = 'Nenhuma disciplina foi selecionada para envio'
      return redirect_to manager_path
    end

    params[:discipline_ids].each do |discipline_id|
      Form.create! template: Template.find(params[:template_id]), discipline: Discipline.find(discipline_id)
    end

    flash[:success] = 'Formulários enviados com sucesso'
    redirect_to manager_path
  end
end
