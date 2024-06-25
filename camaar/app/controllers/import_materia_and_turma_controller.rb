class ImportMateriaAndTurmaController < ApplicationController
  def create
    materia_data = JSON.parse(params[:data], symbolize_names: true) rescue nil
    if materia_data.present?
      begin
        import_materias(materia_data)
        render json: { message: "Data imported successfully!" }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: "Error importing data: #{e.message}" }, status: :bad_request
      end
    else
      render json: { message: "Invalid JSON data format." }, status: :bad_request
    end
  end

  private

  def import_materias(materia_data_array)
    materia_data_array.each do |materia_data|
      materia = Materia.create!(codigo: materia_data[:code], nome: materia_data[:name])
      turma_data = materia_data[:class]
      turma = materia.turmas.create!(codigo: turma_data[:classCode], semestre: turma_data[:semester], horario: turma_data[:time])
    end
  end
end
