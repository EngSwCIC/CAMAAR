class LikertScalesController < ApplicationController
  before_action :set_likert_scale, only: %i[ show update destroy ]

  # GET /likert_scales
  def index
    @likert_scales = LikertScale.all

    render json: @likert_scales
  end

  # GET /likert_scales/1
  def show
    render json: @likert_scale
  end

  # POST /likert_scales
  def create
    @likert_scale = LikertScale.new(likert_scale_params)

    if @likert_scale.save
      render json: @likert_scale, status: :created, location: @likert_scale
    else
      render json: @likert_scale.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /likert_scales/1
  def update
    if @likert_scale.update(likert_scale_params)
      render json: @likert_scale
    else
      render json: @likert_scale.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likert_scales/1
  def destroy
    @likert_scale.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_likert_scale
      @likert_scale = LikertScale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def likert_scale_params
      params.fetch(:likert_scale, {})
    end
end
