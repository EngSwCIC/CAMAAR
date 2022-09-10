class MemberCclassesController < ApplicationController
  def create
    member_cclass = MemberCclass.new(member_cclass_params)
    member_cclass.save!

    render json: member_cclass, status: :created

  rescue StandardError => e
    render json: { message: e }, status: :bad_request
  end

  def index
    member_cclasses = MemberCclass.all

    render json: member_cclasses, status: :ok

  rescue StandardError => e
    render json: { message: e }, status: :bad_request
  end

  def destroy
    member_cclass = MemberCclass.find(params[:id])
    member_cclass.destroy!

    render json: member_cclass, status: :ok

  rescue StandardError => e
    render json: { message: e }, status: :bad_request
  end

  private

  def member_cclass_params
    params.require(:member_cclass).permit(:grade, :member_id, :cclass_id)
  end

end
