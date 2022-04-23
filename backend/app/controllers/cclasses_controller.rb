class CclassesController < ApplicationController
  def index
    head :not_found and return if params[:member_id].nil?
    @member = Member.find(params[:member_id])

    if !@member.blank?
      @cclasses = []
      for enrollment in @member.enrollments do
        @cclasses.push(enrollment.cclass)
      end

      render json: @cclasses, include: :subject
    else
      head :not_found
    end
  end
end
