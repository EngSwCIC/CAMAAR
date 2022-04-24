require 'rails_helper'

RSpec.describe SurveyAnswer, type: :model do
    before(:each) do
        @survey = Survey.new(name:"Survey", description:"description", semester:"2021.2")

        @subject = Subject.new(code: "code", name: "name")
        @cclass = Cclass.new(code: "classcode", semester: "semester", time: "time", subject: @subject)
        @member = Member.new(name: "Nome", course: "Departamento",
            registration: "83807519491", username: "83807519491",
            degree: "DOUTORADO",
            email: "email@gmail.com")        
    end

    context 'Checar criação de formulários de respostas' do
        it 'Quando tento criar formulário como docente' do
            @member.occupation = "docente"
            @enrollment = Enrollment.new(cclass: @cclass, member: @member)
            survey_answer = SurveyAnswer.new(enrollment: @enrollment, survey: @survey)

            expect(survey_answer).to be_valid
        end

        it 'Quando tento criar formulário como discente' do
            @member.occupation = "discente"
            @enrollment = Enrollment.new(cclass: @cclass, member: @member)
            survey_answer = SurveyAnswer.new(enrollment: @enrollment, survey: @survey)

            expect(survey_answer).to_not be_valid
        end
    end
end
