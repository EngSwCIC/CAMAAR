class SubjectsController < ApplicationController
  def index
    head :not_found if params[:member_id].nil?
    @enrollments = Enrollment.where(member_id: params[:member_id])
    puts "Enrollments for member #{params[:member_id]}: #{@enrollments.inspect}"

    @subjects = []
    for enrollment in @enrollments do
      @subjects.push(enrollment.cclass.subject)
    end

    render json: @subjects
  end
end
