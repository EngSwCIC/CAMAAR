class MembersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:redefine_password]

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
    @member = Member.find_by_id(params[:id])
    render json: @member, status: :ok
  end

  # #
  # Procura por um membro específico baseado no seu hash de redefinição.
  #
  # Recebe um hash de redefinição, procura um membro que possui esse hash e o retorna.
  def redefine_password
    @member = Member.where(redefinition_link: params[:redefinition_link])[0]
    render json: @member, status: :ok
  end
end
