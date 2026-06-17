class DiscentesController < ApplicationController
  before_action :set_discente, only: %i[ show edit update destroy ]

  # GET /discentes or /discentes.json
  def index
    @discentes = Discente.all
  end

  # GET /discentes/1 or /discentes/1.json
  def show
  end

  # GET /discentes/new
  def new
    @discente = Discente.new
  end

  # GET /discentes/1/edit
  def edit
  end

  # POST /discentes or /discentes.json
  def create
    @discente = Discente.new(discente_params)

    respond_to do |format|
      if @discente.save
        format.html { redirect_to @discente, notice: "Discente was successfully created." }
        format.json { render :show, status: :created, location: @discente }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @discente.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /discentes/1 or /discentes/1.json
  def update
    respond_to do |format|
      if @discente.update(discente_params)
        format.html { redirect_to @discente, notice: "Discente was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @discente }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @discente.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /discentes/1 or /discentes/1.json
  def destroy
    @discente.destroy!

    respond_to do |format|
      format.html { redirect_to discentes_path, notice: "Discente was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discente
      @discente = Discente.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def discente_params
      params.expect(discente: [ :matricula, :email, :nome, :formacao, :curso_id ])
    end
end
