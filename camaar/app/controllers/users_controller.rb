class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_data
  layout "user"

  def index
  end

  def new
  end

  def create
  end


  def show
    # @templates = Template.where(coordinator_id: @coordinator.id)
    check_for_commit
  end

  def edit
    # @templates = Template.where(coordinator_id: @coordinator.id)
  end

  def update

  end

  def page

  end
  def destroy
    # @templates = Template.where(coordinator_id: @coordinator.id)
    # template = @template.destroy

    # if template
      # redirect_to templates_path
    # end
  end


  private

  def require_user
    @user = User.find_by_id(params[:id])
    redirect_to root_url if @user.nil?
  end

end
