require 'rails_helper'

RSpec.describe Answer, type: :model do
  before(:each) do
    @survey = Survey.new(name:"Survey", description:"description", semester:"2021.2")
    @subject = Subject.new(code: "code", name: "name")
    @cclass = Cclass.new(code: "classcode", semester: "semester", time: "time", subject: @subject)
    @member = Member.new(name: "Nome",
      occupation: "docente",
      course: "Departamento",
      registration: "83807519491", username: "83807519491",
      degree: "DOUTORADO",
      email: "email@gmail.com")  
    @enrollment = Enrollment.new(cclass: @cclass, member: @member)
    @surveyAnswers = SurveyAnswer.new(enrollment: @enrollment, survey: @survey)

    @surveyQuestion = SurveyQuestion.new(question_type: 'Escala', question: 'Pergunta', optional: false, survey:@survey)
  end

  context 'Checar criação de resposta para um formulário' do
    it 'Quando tento criar resposta para uma questão obrigatória' do
      answer = Answer.new(survey_question: @surveyQuestion, survey_answer: @surveyAnswers, content: "5");
      expect(answer).to be_valid
    end

    it 'Quando tento criar resposta sem uma questão' do
      teste = Answer.new(survey_answer: @surveyAnswers, content: "5");
      expect(teste).to_not be_valid
    end
  end
end
