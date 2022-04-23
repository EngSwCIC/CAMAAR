class ScrapperController < ApplicationController
    
  def headers
      {
        'Accept': 'application/json',
        'Content-type': 'application/json'
      }
  end

  def index
      params = request.body.read
      url = 'http://localhost:3030/participantes'
      resultado = RestClient.post(url, params, :content_type => 'application/json', :accept => 'application/json')
      resultado = JSON.parse(resultado.body)
      puts resultado
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

    def show
        request = Api::SearchClasses.call
        #render json: request, status: :ok
    
        JSON.parse(request).each do |turma|
            subject = Subject.create!(code: turma['code'], name: turma['name'])
            class_info = turma['class']
            Cclass.create!(code: class_info['classCode'], semester: class_info['semester'], time: class_info['time'], subject: subject)
        end
        render json: {
            classes: JSON.parse(request)
        }, status: :ok

    end
end