class CamposController < ApplicationController
  before_action :set_campo, only: %i[ show edit update destroy ]

  # GET /campos or /campos.json
  def index
    @campos = Campo.all
  end

  # GET /campos/1 or /campos/1.json
  def show
  end

  # GET /campos/new
  def new
    @campo = Campo.new
  end

  # GET /campos/1/edit
  def edit
  end

  # POST /campos or /campos.json
  def create
    @campo = Campo.new(campo_params)

    respond_to do |format|
      if @campo.save
        format.html { redirect_to @campo, notice: "Campo was successfully created." }
        format.json { render :show, status: :created, location: @campo }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @campo.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /campos/1 or /campos/1.json
  def update
    respond_to do |format|
      if @campo.update(campo_params)
        format.html { redirect_to @campo, notice: "Campo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @campo }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @campo.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /campos/1 or /campos/1.json
  def destroy
    @campo.destroy!

    respond_to do |format|
      format.html { redirect_to campos_path, notice: "Campo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campo
      @campo = Campo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def campo_params
      params.expect(campo: [ :ordem, :enunciado, :tipo_elemento, :elemento_id ])
    end
end
