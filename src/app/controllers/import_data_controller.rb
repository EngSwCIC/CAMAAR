# trabalhar com arquivos json e criar link de redefinicao de senha unico
# usando o e-mail do participante
require 'json'
require 'digest'


class DataImportController < ApplicationController
  ##
  # Lê informações de um arquivo JSON enviado pelo usuário e cadastra no banco de dados
  #
  # Caso a importação e o cadastro sejam bem-sucedidos, é retornado status 200
  # com a mensagem: "Participantes importados com sucesso"
  def create

    # verifica se o arquivo foi enviado, cc. retorna erro
    if params[:file].nil?
      return render json: { message: 'Arquivo não enviado' }, status: :bad_request
    end

    # lê arquivo e converte de JSON -> objeto ruby resultado
    file = params[:file].read
    resultado = JSON.parse(file)

    # para cada grupo de participantes, encontra a turma correspondente
    # e chama cadastraParticipantes para salvar no banco de dados
    resultado.each do |participantes|
      turma = resultado['classes'].select do |turma|
                turma['codigo'] == participantes['code'] && turma['turma'] == participantes['classCode']
              end[0]
      cadastraParticipantes(participantes, turma)
    end

    render json: {
      message: 'Participantes importados com sucesso'
    }, status: :ok
  end

  private

  ##
  # Cadastra as informações das turmas e dos participantes importados no banco de dados
  def cadastraParticipantes(participantes, turma)

    # encontra ou cria a matéria
    subject = Subject.where(
      code: turma['codigo'],
      name: turma['nome']
    ).first_or_create

    # encontra ou cria a turma (cclass)
    turma = Cclass.where(
      code: turma['turma'],
      semester: turma['semestre'],
      time: turma['horario'],
      subject: subject
    ).first_or_create

    # cadastra cada participante
    participantes['dicente'].each do |discente|
      cadastraParticipante(discente, turma)
    end
  end

  ##
  # Cadastra os participantes importados no banco de dados.
  #
  # Cada participante recebe uma hash de redefinição única baseada
  # no seu email. Ao terminar, um email é enviado ao aluno com um link para
  # redefinição de senha.
  def cadastraParticipante(discente, turma)
    role = Role.find_or_create_by(name: :discente)

    # encontra ou cria um membro (member)
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

    # cria senha automatica
    random_password = "senha_automatica"
    user = User.find_or_create_by(
      email: discente['email'],
      password: random_password,
      password_confirmation: random_password,
      member_id: member.id
    )

    # encontra ou cria a inscrição
    Enrollment.find_or_create_by(
      member: member,
      cclass: turma
    )

    # TODO: generate redefinition link and attach to the member object
    mail = ApplicationMailer.redefine_password(member, random_password)
    # mail.deliver_now
  end
end

'''
ORDEM

Lê e converte o JSON para um objeto Ruby.
Para cada grupo de participantes (participantes):
Encontra a turma correspondente.
Cadastra a matéria (Subject).
Cadastra a turma (Cclass).
Para cada participante (dicente):
Cadastra o participante (Member).
Cadastra o usuário (User).
Cadastra a inscrição (Enrollment).
(Opcional) Envia um email para redefinição de senha.
'''

# cada Subject, Cclass, etc é um modelo de ActiveRecord, que 
# representará, nesse caso, uma matéria no banco de dados
# subject será uma instância da classe Subject
# codigo procura no banco de dados um registro na tabela subjects
# que tenha o codigo e o nome especificados. Se nao encontrar, cria
# um novo registro com esses atributos

''' exemplo do arquivo JSON
{
  "classes": [
    {
      "codigo": "MAT101",
      "nome": "Matemática Básica",
      "turma": "A",
      "semestre": "2024.1",
      "horario": "08:00-10:00"
    }
  ],
  "participantes": [
    {
      "code": "MAT101",
      "classCode": "A",
      "dicente": [
        {
          "nome": "João Silva",
          "curso": "Engenharia",
          "matricula": "123456",
          "usuario": "joaos",
          "formacao": "Graduando",
          "email": "joao.silva@example.com"
        }
      ]
    }
  ]
}

'''
