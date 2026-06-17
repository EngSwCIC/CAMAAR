class CampoFormsController < ApplicationController
  before_action :set_campo_form, only: %i[ show edit update destroy ]

  # GET /campo_forms or /campo_forms.json
  def index
    @campo_forms = CampoForm.all
  end

  # GET /campo_forms/1 or /campo_forms/1.json
  def show
  end

  # GET /campo_forms/new
  def new
    @campo_form = CampoForm.new
  end

  # GET /campo_forms/1/edit
  def edit
  end

  # POST /campo_forms or /campo_forms.json
  def create
    @campo_form = CampoForm.new(campo_form_params)

    respond_to do |format|
      if @campo_form.save
        format.html { redirect_to @campo_form, notice: "Campo form was successfully created." }
        format.json { render :show, status: :created, location: @campo_form }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @campo_form.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /campo_forms/1 or /campo_forms/1.json
  def update
    respond_to do |format|
      if @campo_form.update(campo_form_params)
        format.html { redirect_to @campo_form, notice: "Campo form was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @campo_form }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @campo_form.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /campo_forms/1 or /campo_forms/1.json
  def destroy
    @campo_form.destroy!

    respond_to do |format|
      format.html { redirect_to campo_forms_path, notice: "Campo form was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campo_form
      @campo_form = CampoForm.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def campo_form_params
      params.expect(campo_form: [ :ordem, :enunciado, :elemento_form_id ])
    end
end
