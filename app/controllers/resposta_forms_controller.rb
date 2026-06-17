class RespostaFormsController < ApplicationController
  before_action :set_resposta_form, only: %i[ show edit update destroy ]

  # GET /resposta_forms or /resposta_forms.json
  def index
    @resposta_forms = RespostaForm.all
  end

  # GET /resposta_forms/1 or /resposta_forms/1.json
  def show
  end

  # GET /resposta_forms/new
  def new
    @resposta_form = RespostaForm.new
  end

  # GET /resposta_forms/1/edit
  def edit
  end

  # POST /resposta_forms or /resposta_forms.json
  def create
    @resposta_form = RespostaForm.new(resposta_form_params)

    respond_to do |format|
      if @resposta_form.save
        format.html { redirect_to @resposta_form, notice: "Resposta form was successfully created." }
        format.json { render :show, status: :created, location: @resposta_form }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @resposta_form.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /resposta_forms/1 or /resposta_forms/1.json
  def update
    respond_to do |format|
      if @resposta_form.update(resposta_form_params)
        format.html { redirect_to @resposta_form, notice: "Resposta form was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @resposta_form }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @resposta_form.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /resposta_forms/1 or /resposta_forms/1.json
  def destroy
    @resposta_form.destroy!

    respond_to do |format|
      format.html { redirect_to resposta_forms_path, notice: "Resposta form was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resposta_form
      @resposta_form = RespostaForm.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def resposta_form_params
      params.expect(resposta_form: [ :data_submissao, :formulario_id, :usuario_id ])
    end
end
