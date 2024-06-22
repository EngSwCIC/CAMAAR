# trabalhar com arquivos json e criar link de redefinicao de senha unico
# usando o e-mail do participante
require 'json'
require 'digest'


class ImportDataController < ApplicationController
  ##
  # Lê informações de um arquivo JSON enviado pelo usuário e cadastra no banco de dados
  #
  # Caso a importação e o cadastro sejam bem-sucedidos, é retornado status 200
  # com a mensagem: "Participantes importados com sucesso"
  def create

    # verifica se o arquivo foi enviado, cc. retorna erro
    if params.nil?
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
    materia = Materia.where(
      code: turma['codigo'],
      name: turma['nome']
    ).first_or_create



    # encontra ou cria a turma (cclass)
    turma = Turma.where(
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

    # Cadastra o usuário no Banco de Dados se ainda não cadastrado 
    # envia confirmação e link para definir senha por e-mail
    cadastraUsuario(discente)

    # encontra ou cria a inscrição
    Enrollment.find_or_create_by(
      member: member,
      cclass: turma
    )

    # TODO: generate redefinition link and attach to the member object
    mail = ApplicationMailer.redefine_password(member, random_password)
    # mail.deliver_now
  end
  def cadastraUsuario(discente)
    # Cria a conta com uma senha arbitrária.
    # Depende da confirmação do usuário, que definirá a senha
    password = 'senha_arbitraria'
    # Pesquisa se o usuário já se encontra no Banco de Dados
    user_pesquisa = User.find_by_email(discente[:email])
    if user_pesquisa.nil? && !(discente[:email].nil?)
      @user = User.new(
        nome: discente[:nome], 
        email: discente[:email], 
        curso: discente[:curso], 
        matricula: discente[:matricula], 
        usuario: discente[:usuario], 
        formacao: discente[:formacao], 
        ocupacao: discente[:ocupacao], 
        password: password, 
        password_confirmation: password
        )

      @user.skip_confirmation_notification! 
      @user.save
      @user.send_reset_password_instructions

    end
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
