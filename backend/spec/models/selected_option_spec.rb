require 'rails_helper'

RSpec.describe SelectedOption, type: :model do
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
    @survey_answers = SurveyAnswer.new(enrollment: @enrollment, survey: @survey)
    @survey_question = SurveyQuestion.new(question_type: 'Caixa de Seleção', question: 'Pergunta1', optional: false, survey:@survey)

    @answer = Answer.new(survey_question: @surveyQuestion, survey_answer: @survey_answers);

    @option = Option.new(option: "Opção", survey_question: @survey_question)
  end

  context 'Checar seleção de opção para perguntas' do
    it 'Quando tento criar uma opção selecionada para uma pergunta válida' do
      selected_option = SelectedOption.new(option: @option, answer: @answer)
      expect(selected_option).to be_valid
    end

    it 'Quando tento criar uma opção selecionada sem atribuir a uma resposta' do
      selected_option = SelectedOption.new(option: @option)
      expect(selected_option).to_not be_valid
    end
  end
end
