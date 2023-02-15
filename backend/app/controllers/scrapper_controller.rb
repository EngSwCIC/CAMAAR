##
# Esta classe é responsavel por fazer o intermédio entre o scrapper e o frontend,
# bem como o cadastro das informações resultantes do scrapper
require 'digest'
class ScrapperController < ApplicationController
  ##
  # Extrai informações das turmas do SIGAA através do scrapper
  #
  # Caso não recebe nada para importar ele entende que foi importado com sucesso
  #
  # Se trouxer informações ele irá cadastrar no banco de dados a informações extraídas
  #
  # Caso tenha sucesso em extraír e gravar no banco de dados é retornando status 200 e
  # a mensagem: "Participantes importados com sucesso"
  def index
    params = request.body.read
    resultado = Api::ImportData.call(params)
    resultado = JSON.parse(resultado)

    resultado.each do |participantes|
      turma = JSON.parse(params)['classes'].select do |turma|
                turma['codigo'] == participantes['code'] && turma['turma'] == participantes['classCode']
              end[0]
      cadastraParticipantes(participantes, turma)
    end

    render json: {
      message: 'Participantes importados com sucesso'
    }, status: :ok
  end

  ##
  # Importa as informações das turmas disponíveis para o scrapper
  #
  # Retorna as informações das turmas como JSON
  def show
    request = Api::SearchClasses.call

    render json: {
      classes: JSON.parse(request)
    }, status: :ok
  end

  private

  ##
  # Cadastra as informações das turmas importadas do sigaa no banco de dados
  def cadastraParticipantes(participantes, turma)
    subject = Subject.where(
      code: turma['codigo'],
      name: turma['nome']
    ).first_or_create

    turma = Cclass.where(
      code: turma['turma'],
      semester: turma['semestre'],
      time: turma['horario'],
      subject: subject
    ).first_or_create

    participantes['dicente'].each do |discente|
      cadastraParticipante(discente, turma)
    end
  end

  ##
  # Cadastra os participantes importados no banco de dados
  def cadastraParticipante(discente, turma)
    role = Role.find_or_create_by(name: :discente)

    member = Member.find_or_create_by(
      name: discente['nome'],
      course: discente['curso'],
      registration: discente['matricula'],
      username: discente['usuario'],
      degree: discente['formacao'],
      role: role,
      email: discente['email'],
      redefinition_link: Digest::SHA256.hexdigest(discente['email'])
    )

    random_password = "senha_automatica"
    user = User.find_or_create_by(
      email: discente['email'],
      password: random_password,
      password_confirmation: random_password,
      member_id: member.id
    )

    Enrollment.find_or_create_by(
      member: member,
      cclass: turma
    )

    # TODO: generate redefinition link and attach to the member object
    mail = ApplicationMailer.redefine_password(member)
    # mail.deliver_now
  end
end

