class RespostaElemsController < ApplicationController
  before_action :set_resposta_elem, only: %i[ show edit update destroy ]

  # GET /resposta_elems or /resposta_elems.json
  def index
    @resposta_elems = RespostaElem.all
  end

  # GET /resposta_elems/1 or /resposta_elems/1.json
  def show
  end

  # GET /resposta_elems/new
  def new
    @resposta_elem = RespostaElem.new
  end

  # GET /resposta_elems/1/edit
  def edit
  end

  # POST /resposta_elems or /resposta_elems.json
  def create
    @resposta_elem = RespostaElem.new(resposta_elem_params)

    respond_to do |format|
      if @resposta_elem.save
        format.html { redirect_to @resposta_elem, notice: "Resposta elem was successfully created." }
        format.json { render :show, status: :created, location: @resposta_elem }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @resposta_elem.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /resposta_elems/1 or /resposta_elems/1.json
  def update
    respond_to do |format|
      if @resposta_elem.update(resposta_elem_params)
        format.html { redirect_to @resposta_elem, notice: "Resposta elem was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @resposta_elem }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @resposta_elem.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /resposta_elems/1 or /resposta_elems/1.json
  def destroy
    @resposta_elem.destroy!

    respond_to do |format|
      format.html { redirect_to resposta_elems_path, notice: "Resposta elem was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resposta_elem
      @resposta_elem = RespostaElem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def resposta_elem_params
      params.expect(resposta_elem: [ :texto_resposta, :resposta_form_id, :elemento_form_id, :campo_form_id ])
    end
end
