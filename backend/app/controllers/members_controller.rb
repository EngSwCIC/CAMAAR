class MembersController < ApplicationController
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

  def get
    @member = Member.where(redefinition_link: params[:redefinition_link])[0]
    render json: @member, status: :ok
  end
end
