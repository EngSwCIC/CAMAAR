class MateriaController < ApplicationController
  before_action :set_materia, only: %i[show edit update destroy]

  # GET /materia or /materia.json
  def index
    @materia = Materia.all
  end

  # GET /materia/1 or /materia/1.json
  def show
  end

  # GET /materia/new
  def new
    @materia = Materia.new
  end

  # GET /materia/1/edit
  def edit
  end

  # POST /materia or /materia.json
  def create
    @materia = Materia.new(materia_params)

    respond_to do |format|
      if @materia.save
        format.html { redirect_to materia_url(@materia), notice: "Materia was successfully created." }
        format.json { render :show, status: :created, location: @materia }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @materia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materia/1 or /materia/1.json
  def update
    respond_to do |format|
      if @materia.update(materia_params)
        format.html { redirect_to materia_url(@materia), notice: "Materia was successfully updated." }
        format.json { render :show, status: :ok, location: @materia }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @materia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materia/1 or /materia/1.json
  def destroy
    @materia.destroy

    respond_to do |format|
      format.html { redirect_to materias_url, notice: "Materia was successfully destroyed." }
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
    def set_materia
      @materia = Materia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def materia_params
      params.require(:materia).permit(:codigo, :semestre, :nome, :departamento, :professor_id, :aluno_id, :forms_materia)
    end
    
    def save_sigaa_classes(classes)
      @sigaa_classes = classes
    end
end
