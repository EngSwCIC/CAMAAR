class ImportDataController < ApplicationController
  def create
    if params[:file].nil?
      return render json: { message: 'Arquivo não enviado' }, status: :bad_request
    end

    begin
      file = params[:file].read
      resultado = JSON.parse(file)

      resultado['participantes'].each do |participantes|
        turma = resultado['classes'].find do |turma|
          turma['codigo'] == participantes['code'] && turma['turma'] == participantes['codigo']
        end

        cadastraParticipantes(participantes, turma)
      end

      render json: { message: 'Participantes importados com sucesso' }, status: :ok
    rescue JSON::ParserError => e
      render json: { message: 'Erro ao analisar o arquivo JSON', error: e.message }, status: :bad_request
    end
  end

  private

  def cadastraParticipantes(participantes, turma)
    materia = Materia.where(
      classCode: turma['codigo'],
      nome: turma['nome']
    ).first_or_create

    turma = Turma.where(
      classCode: turma['turma'],
      semester: turma['semestre'],
      time: turma['horario'],
      subject: materia
    ).first_or_create

    participantes['dicente'].each do |discente|
      cadastraParticipante(discente, turma)
    end
  end

  def cadastraParticipante(discente, turma)
    role = Role.find_or_create_by(name: :discente)
    cadastraUsuario(discente)

    Enrollment.find_or_create_by(
      member: member,
      classCode: turma
    )

    # Generate reset password link and send email
    # mail = ApplicationMailer.redefine_password(member, random_password)
    # mail.deliver_now
  end

  def cadastraUsuario(discente)
    password = 'senha_arbitraria'
    user_pesquisa = User.find_by_email(discente['email'])

    if user_pesquisa.nil? && discente['email'].present?
      @user = User.new(
        nome: discente['nome'], 
        email: discente['email'], 
        curso: discente['curso'], 
        matricula: discente['matricula'], 
        usuario: discente['usuario'], 
        formacao: discente['formacao'], 
        ocupacao: discente['ocupacao'], 
        password: password, 
        password_confirmation: password
      )

      @user.skip_confirmation_notification! 
      @user.save
      @user.send_reset_password_instructions
    end
  end
end
