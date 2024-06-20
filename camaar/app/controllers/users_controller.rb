class UsersController < ApplicationController
  # def login
  #   user = User.find_by(email: login_params[:email])
  #   if user.valid_password?(login_params[:password])
  #       render json: user, status: :ok
  #   else
  #       head :unauthorized
  #   end
  # rescue StandardError => e
  #     head :unauthorized
  # end
  #
  def index
      users = User.all
      render json: array_serializer(users), status: :ok
  rescue StandardError => e
      render json: e, status: :not_found
  end

  def show
      user = User.find(params[:id])
      render json: serializer(user), status: :ok
  rescue StandardError => e
      render json: e, status: :not_found
  end

  def create
    class_members = JSON.parse(params[:data], symbolize_names: true) rescue nil
    if class_members.present?
      begin
        import_users(class_members)
        render json: { message: "Data imported successfully!" }, status: :created
      rescue StandardError => e
        render json: { message: "Error importing data: #{e.message}" }, status: :bad_request
      end
    else
      render json: { message: "Invalid JSON data format." }, status: :bad_request
    end
  end

  def update
      user = User.find(params[:id])
      user.update!(user_params)
      render json: user, status: :ok
  rescue StandardError => e
      render json: e, status: :bad_request
  end

  def delete
      user = User.find(params[:id])
      user.destroy!
      render json: user, status: :ok
  rescue StandardError => e
      render json: e, status: :not_found
  end

  private

  # def login_params
  #     params.require(:user).permit(:email, :password)
  # end

  def user_params
    params.require(:user).permit(:nome, :email, :password, :curso, :matricula, :formacao, :ocupacao)
  end

  def serializer(user)
    UserSerializer.new.serialize_to_json(user)
  end

  def array_serializer(users)
    Panko::ArraySerializer.new(users, each_serializer: UserSerializer).to_json
  end

  def import_users(class_members_data_array)
    class_members_data_array.each do |materia_data|
      materia = Materia.find_or_create_by(codigo: materia_data[:code])  # Search by code only

      turma = materia.turmas.find_or_create_by(codigo: materia_data[:classCode], semestre: materia_data[:semester], horario: materia_data[:time])

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
