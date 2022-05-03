class ScrapperController < ApplicationController
    
  def headers
      {
        'Accept': 'application/json',
        'Content-type': 'application/json'
      }
  end

  def index
      params = request.body.read
      turmasScrapper = []
      JSON.parse(params)['classes'].each do |turma|
        turmasScrapper.append({:code => turma['codigo'], :classCode => turma['turma']})
        subject = Subject.create!(code: turma['codigo'], name: turma['nome'])
        Cclass.create!(code: turma['turma'], semester: turma['semestre'], time: turma['horario'], subject: subject)
      end
      
      resultado = Api::ImportData.call(params)
      resultado.each do |participantes|
        puts participantes['code']
        idMateria = Subject.where(code: participantes['code']).first.id
        turma = Cclass.where(subject_id: idMateria, code: participantes['classCode']).first

        participantes['dicente'].each do |discente|
          member=Member.where(registration: discente['matricula']).first
          if Member.exists?(registration: discente['matricula'])
            if !Enrollment.exists?(member: member, cclass: turma)
              Enrollment.create(member: member, cclass: turma)
            end
          else
            member = Member.create(name: discente['nome'], course: discente['curso'],
            registration: discente['matricula'], username: discente['usuario'],
            degree: discente['formacao'], occupation: discente['ocupacao'],
            email: discente['email'])
            Enrollment.create(member: member, cclass: turma) 
          end
        end
      end
      render json: {
          message: 'Participantes importados com sucesso'
      }, status: :ok
  end

  #def parse(request)
  #    JSON.parse(request.body)
  #end

  def show
      #login = { name: '', password: ''}
      
      url = 'http://localhost:3000/turmas'
      request = RestClient.post(url, {}, headers)
     
      # turmasCadastradas = Cclass.joins(:subject).select("cclasses.id, cclasses.code as classCode, cclasses.semester, cclasses.time, subjects.code as code, subjects.name")
      render json: {
          classes: JSON.parse(request.body)
      }, status: :ok

  end
end