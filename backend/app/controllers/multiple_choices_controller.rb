class MultipleChoicesController < ApplicationController
  before_action :set_multiple_choice, only: %i[ show update destroy ]

  # GET /multiple_choices
  def index
    @multiple_choices = MultipleChoice.all

    render json: @multiple_choices
  end

  # GET /multiple_choices/1
  def show
    render json: @multiple_choice
  end

  # POST /multiple_choices
  def create
    @multiple_choice = MultipleChoice.new(multiple_choice_params)

    if @multiple_choice.save
      render json: @multiple_choice, status: :created, location: @multiple_choice
    else
      render json: @multiple_choice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /multiple_choices/1
  def update
    if @multiple_choice.update(multiple_choice_params)
      render json: @multiple_choice
    else
      render json: @multiple_choice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /multiple_choices/1
  def destroy
    @multiple_choice.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_multiple_choice
      @multiple_choice = MultipleChoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def multiple_choice_params
      params.fetch(:multiple_choice, {})
    end
end
