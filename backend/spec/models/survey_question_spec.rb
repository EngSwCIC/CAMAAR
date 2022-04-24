require 'rails_helper'

RSpec.describe SurveyQuestion, type: :model do
  before(:all) do
    @survey = Survey.new(name:"Survey", description:"description", semester:"2021.2")
  end

  context 'Checar criação de questões para o Questionário' do
    it 'Quandos os dados são preenchidos corretamente' do
      survey_question = SurveyQuestion.new(question_type: 'Escala', question: 'Pergunta', optional: true, survey:@survey)
      expect(survey_question).to be_valid
    end

    it 'Quandos o tipo de questão é preenchido incorretamento' do
      survey_question = SurveyQuestion.new(question_type: 'tipo_indefinido', question: 'Pergunta', optional: true, survey:@survey)
      expect(survey_question).to_not be_valid
    end

    it 'Quando não é passado um survey_id' do
      survey_question = SurveyQuestion.new(question_type: 'Escala', question: 'Pergunta', optional: true, survey:nil)
      expect(survey_question).to_not be_valid
    end
  end
end
