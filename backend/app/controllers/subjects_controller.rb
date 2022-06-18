class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
    render json: @subjects, status: :ok
  end

  def show
    @subject = Subject.find(params[:id])
    render json: @subject, status: :ok
  end
end
