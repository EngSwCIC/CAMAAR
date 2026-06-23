class SubmissaosController < ApplicationController
  before_action :set_submissao, only: %i[ show edit update destroy ]

  def index
    @submissaos = Submissao.all
  end

  def show
  end

  def new
    @submissao = Submissao.new
  end

  def edit
  end

  def create
    @submissao = Submissao.new(submissao_params)
    respond_to do |format|
      if @submissao.save
        format.html { redirect_to @submissao, notice: "Submissao was successfully created." }
        format.json { render :show, status: :created, location: @submissao }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @submissao.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @submissao.update(submissao_params)
        format.html { redirect_to @submissao, notice: "Submissao was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @submissao }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @submissao.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @submissao.destroy!
    respond_to do |format|
      format.html { redirect_to submissaos_path, notice: "Submissao was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_submissao
    @submissao = Submissao.find(params.expect(:id))
  end

  def submissao_params
    params.expect(submissao: [ :formulario_id, :user_id ])
  end
end
