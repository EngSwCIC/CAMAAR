# The scrapper controller is responsible for the scrapper import handling
class ScrapperController < ApplicationController
  # Index lida com o import dos participantes e grava tudo no banco
  # O show lida com o search Turmass do scrapper 
  def headers
      {
        'Accept': 'application/json',
        'Content-type': 'application/json'
      }
  end

  def index
      params = request.body.read
      resultado = Api::ImportData.call(params)
      resultado = JSON.parse(resultado)
      resultado.each do |participantes|
        turma = JSON.parse(params)['classes'].select { |turma| turma['codigo']==participantes['code'] && turma['turma']==participantes['classCode']}[0]
        cadastraParticipantes(participantes, turma)        
      end
      render json: {
          message: 'Participantes importados com sucesso'
      }, status: :ok
  end

  def show
    request = Api::SearchClasses.call
    
    render json: {
        classes: JSON.parse(request)
    }, status: :ok
  end

  def cadastraParticipantes(participantes, turma)
    subject = Subject.where(code: turma['codigo'], name:turma['nome']).first_or_create
    turma = Cclass.where(code: turma['turma'], semester: turma['semestre'], time: turma['horario'], subject: subject).first_or_create
    participantes['dicente'].each do |discente|
      cadastraParticipante(discente, turma) 
    end
  end
  def cadastraParticipante(discente, turma)
    member = Member.where(name: discente['nome'], course: discente['curso'],
      registration: discente['matricula'], username: discente['usuario'],
      degree: discente['formacao'], occupation: discente['ocupacao'],
      email: discente['email']).first_or_create
    Enrollment.where(member: member, cclass: turma).first_or_create
  end
end