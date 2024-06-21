class TurmasController < ApplicationController
  before_action :set_turma, only: [:show, :edit, :update, :destroy]

  def index
    @turmas = Turma.all
  end

  def show
  end

  def new
    @turma = Turma.new
    @disciplinas = Disciplina.all
    @docentes = User.where(type: 'Docente')
  end

  # GET /turmas/1/edit
  def edit
    @disciplinas = Disciplina.all
    @docentes = User.where(type: 'Docente')
  end

  # POST /turmas
  def create
    @turma = Turma.new(turma_params)

    if @turma.save
      redirect_to @turma, notice: 'Turma foi criada com sucesso.'
    else
      @disciplinas = Disciplina.all
      @docentes = User.where(type: 'Docente')
      render :new
    end
  end

  # PATCH/PUT /turmas/1
  def update
    if @turma.update(turma_params)
      redirect_to @turma, notice: 'Turma foi atualizada com sucesso.'
    else
      @disciplinas = Disciplina.all
      @docentes = User.where(type: 'Docente')
      render :edit
    end
  end

  def destroy
    @turma.destroy
    redirect_to turmas_url, notice: 'Turma excluída com sucesso.'
  end

  def import
    if request.post?
      file = params[:file]

      if file
        data = JSON.parse(file.read)
        data.each do |class_data|
          turma = Turma.find_or_create_by(
            codigo: class_data['code'],
            class_code: class_data['classCode'],
            semester: class_data['semester']
          )

          instructor_data = class_data['docente']
          user_docente = User.create!(
            nome: instructor_data['nome'],
            email: instructor_data['email'],
            password: '',
            usuario: instructor_data['usuario'],
            formacao: instructor_data['formacao'],
            role: :docente
          )
          Docente.create!(
            user_id: user_docente.id,
            departamento: instructor_data['departamento']
          )
          turma.docente = user_docente

          class_data['dicente'].each do |student_data|
            user_dicente = User.create!(
              nome: student_data['nome'],
              email: student_data['email'],
              password: '',
              usuario: student_data['usuario'],
              formacao: student_data['formacao'],
              role: :dicente
            )
            Dicente.create!(
              user_id: user_dicente.id,
              curso: student_data['curso'],
              matricula: student_data['matricula'],
            )
            # Associa o dicente à turma
            turma.dicentes << user_dicente
            user_dicente.turmas << turma
          end
        end

        render json: { message: 'Turmas imported successfully' }, status: :ok
      else
        render json: { error: 'No file provided' }, status: :unprocessable_entity
      end
    else
      render :import
    end
  end

  private

  def set_turma
    @turma = Turma.find(params[:id])
  end

  def turma_params
    params.require(:turma).permit(:class_code, :semestre, :horario, :disciplina_id, :docente_id)
  end
end
