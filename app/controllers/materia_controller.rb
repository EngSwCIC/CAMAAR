class MateriaController < ApplicationController
  before_action :set_materium, only: %i[ show edit update destroy ]
  @sigaa_classes = nil

  # GET /materia or /materia.json
  def index
    @materia = Materium.all
  end

  # GET /materia/1 or /materia/1.json
  def show
  end

  # GET /materia/new
  def new
    @materium = Materium.new
  end

  # GET /materia/1/edit
  def edit
  end

  # POST /materia or /materia.json
  def create
    @materium = Materium.new(materium_params)

    respond_to do |format|
      if @materium.save
        format.html { redirect_to materium_url(@materium), notice: "Materium was successfully created." }
        format.json { render :show, status: :created, location: @materium }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @materium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materia/1 or /materia/1.json
  def update
    respond_to do |format|
      if @materium.update(materium_params)
        format.html { redirect_to materium_url(@materium), notice: "Materium was successfully updated." }
        format.json { render :show, status: :ok, location: @materium }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @materium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materia/1 or /materia/1.json
  def destroy
    @materium.destroy!

    respond_to do |format|
      format.html { redirect_to materia_url, notice: "Materium was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET
  def search_in_sigaa
    begin
      sigaa_materiums = Materium.get_sigaa_classes
      is_outdated = false

      sigaa_materiums.each do |sigaa_materium|
        if Materium.find_by_codigo(sigaa_materium['code']).nil?
          is_outdated = true
          break
        else
          next
        end
      end

      if is_outdated
        save_sigaa_classes(sigaa_materiums)
        flash[:notice] = "Importação realizada com sucesso"
      else
        flash[:notice] = "Turmas já se encontram atualizadas"
      end

    rescue Materium::ConnectionTimeoutError
      flash[:warning] = "Erro ao conectar com o banco de dados. Tente novamente mais tarde."
    end
  end

  # POST
  def update_with_sigaa_data
    begin
      if @sigaa_classes == nil
        flash[:warning] = "Primeiro verifique se há atualizações do SIGAA"
      else
        @sigaa_classes.each do |sigaa_materium|
          data = {
            codigo: sigaa_materium['code'],
            nome: sigaa_materium['name'],
            semestre: sigaa_materium['semester'],
            horario: sigaa_materium['class']['time'],
            departamento_id: 1
          }
          if Materium.find_by_codigo(sigaa_materium['code']).nil?
            Materium.create(data)
          else
            Materium.find_by_codigo(sigaa_materium['code']).update(data)
          end
        end

        flash[:notice] = "Turmas importadas com sucesso do SIGAA"
      end
    rescue
      flash[:warning] = "Erro, não foi possível concluir a operação"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_materium
      @materium = Materium.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def materium_params
      params.require(:materium).permit(:codigo, :semestre, :nome, :departamento, :professor_id, :aluno_id, :forms_materia)
    end

    def save_sigaa_classes(classes)
      @sigaa_classes = classes
    end
end
