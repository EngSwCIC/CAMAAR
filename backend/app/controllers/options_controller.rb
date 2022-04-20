class OptionsController < ApplicationController
  before_action :set_option, only: %i[ show update destroy ]

  # GET /options
  def index
    @options = Option.all

    render json: @options
  end

  # GET /options/1
  def show
    render json: @option
  end

  # POST /options
  def create
    @option = Option.new(option_params)

    if @option.save
      render json: @option, status: :created, location: @option
    else
      render json: @option.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /options/1
  def update
    if @option.update(option_params)
      render json: @option
    else
      render json: @option.errors, status: :unprocessable_entity
    end
  end

  # DELETE /options/1
  def destroy
    @option.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_option
      @option = Option.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def option_params
      params.require(:option).permit(:option)
    end
end
