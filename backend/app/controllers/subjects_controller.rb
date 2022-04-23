class SubjectsController < ApplicationController
  def index
    head :not_found and return if params[:member_id].nil?
    @member = Member.find(params[:member_id])

    if !@member.blank?
      @subjects = []
      for enrollment in @member.enrollments do
        @subjects.push(enrollment.cclass.subject)
      end

      render json: @subjects
    else
      head :not_found
    end
  end
end
