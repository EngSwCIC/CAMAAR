class MembersController < ApplicationController
  before_action :authenticate_user!
  def index
    @members = if params[:id].present?
                 cclass = Cclass.find(params[:id])
                 cclass.members
               else
                 Member.all
               end
    render json: @members, status: :ok
  end

  def show
    @member = Member.find(params[:id])
    render json: @member, status: :ok
  end

  # #
  # Procura por um membro específico baseado no seu hash de redefinição.
  def redefine_password
    @member = Member.where(redefinition_has: params[:redefinition_link])[0]
    render json: @member, status: :ok
  end
end
