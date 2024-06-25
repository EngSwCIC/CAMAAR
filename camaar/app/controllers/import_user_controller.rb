class ImportUserController < ApplicationController
  def create
    class_members = JSON.parse(params[:data], symbolize_names: true) rescue nil
    if class_members.present?
      begin
        import_materias(class_members)
        render json: { message: "Data imported successfully!" }, status: :created
      rescue StandardError => e
        render json: { message: "Error importing data: #{e.message}" }, status: :bad_request
      end
    else
      render json: { message: "Invalid JSON data format." }, status: :bad_request
    end
  end

  private

  def import_materias(class_members_data_array)
    class_members_data_array.each do |materia_data|
      materia = Materia.find_by(codigo: materia_data[:code])  # Search by code only

      turma = materia.turmas.find_or_create_by(codigo: turma_data[:classCode], semestre: turma_data[:semester], horario: turma_data[:time])

      # Import dicentes (students)
      dicente_data_array = materia_data[:dicente]
      dicente_data_array.each do |dicente_data|
        user = User.find_or_create_by(email: dicente_data[:email], matricula: dicente_data[:matricula])
        user.update!(nome: dicente_data[:nome], curso: dicente_data[:curso],
        formacao: dicente_data[:formacao], ocupacao: dicente_data[:ocupacao], role: :user)

        # Associate user with turma through matricula
        matricula = Matricula.find_or_create_by(user: user, turma: turma)
      end

      # Import docente (teacher)
      docente_data = materia_data[:docente]
      user = User.find_or_create_by(email: docente_data[:email], matricula: docente_data[:matricula])
      user.update!(nome: docente_data[:nome], departamento: docente_data[:departamento],
       formacao: docente_data[:formacao], ocupacao: docente_data[:ocupacao], role: :user)

      # Associate user (docente) with turma through matricula
      matricula = Matricula.find_or_create_by(user: user, turma: turma)


    end
  end
end
