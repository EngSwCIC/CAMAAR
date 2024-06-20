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

  # POST: Gives students of disciplines access to a form copied from the given template
  def send_out_forms
    Rails.logger.debug("Received: #{params[:questions].inspect}")
    return

    params.permit(:id, discipline_ids: %i[id])
    return unless user_authenticated && admin_user? && params.key?(:discipline_ids)

    form = Form.create template: Template.find(params[:id])
    params[:discipline_ids].each do |discipline_id|
      FormDiscipline.create form:, discipline: Discipline.find(discipline_id)
    end
  end
end
