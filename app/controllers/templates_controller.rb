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
    redirect_to root_path unless user_authenticated && admin_user?

    @disciplines = Discipline.all
    @templates = Template.all
    render 'templates/send/index'
  end

  # TODO: Move this route to /templates instead of /templates/:id so that we don't get the template id twice
  # POST: Gives students of disciplines access to a form copied from the given template
  def send_out_forms
    params.permit(:authenticity_token, :commit, :id, :template_id, discipline_ids: [])
    return unless user_authenticated && admin_user?

    form = Form.create template: Template.find(params[:template_id])
    params[:discipline_ids].each do |discipline_id|
      FormDiscipline.create form:, discipline: Discipline.find(discipline_id)
    end
  end
end
