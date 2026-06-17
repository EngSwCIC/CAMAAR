class ElementoFormsController < ApplicationController
  before_action :set_elemento_form, only: %i[ show edit update destroy ]

  # GET /elemento_forms or /elemento_forms.json
  def index
    @elemento_forms = ElementoForm.all
  end

  # GET /elemento_forms/1 or /elemento_forms/1.json
  def show
  end

  # GET /elemento_forms/new
  def new
    @elemento_form = ElementoForm.new
  end

  # GET /elemento_forms/1/edit
  def edit
  end

  # POST /elemento_forms or /elemento_forms.json
  def create
    @elemento_form = ElementoForm.new(elemento_form_params)

    respond_to do |format|
      if @elemento_form.save
        format.html { redirect_to @elemento_form, notice: "Elemento form was successfully created." }
        format.json { render :show, status: :created, location: @elemento_form }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @elemento_form.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /elemento_forms/1 or /elemento_forms/1.json
  def update
    respond_to do |format|
      if @elemento_form.update(elemento_form_params)
        format.html { redirect_to @elemento_form, notice: "Elemento form was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @elemento_form }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @elemento_form.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /elemento_forms/1 or /elemento_forms/1.json
  def destroy
    @elemento_form.destroy!

    respond_to do |format|
      format.html { redirect_to elemento_forms_path, notice: "Elemento form was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elemento_form
      @elemento_form = ElementoForm.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def elemento_form_params
      params.expect(elemento_form: [ :ordem, :enunciado, :formulario_id ])
    end
end
