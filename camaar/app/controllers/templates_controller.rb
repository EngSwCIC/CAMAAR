class TemplatesController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  # @coordinator = Coordinator.find_by({ email: @current_user.email})
  # @department = Department.find_by({ id: @coordinator.department_id })

  def index
  end

  def new
    @template = {}
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
