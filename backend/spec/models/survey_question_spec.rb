require 'rails_helper'

RSpec.describe SurveyQuestion, type: :model do

  before(:all) do
    @survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
  end

  context 'when all attributes is valid' do
    it 'should be valid' do
      survey_q = SurveyQuestion.new(question: 'pergunta teste', question_type: 'discursive', survey: @survey)
      expect(survey_q).to be_valid
    end
  end

  context 'when question is missing' do
    it 'should be invalid' do
      survey_q = SurveyQuestion.new(question_type: 'discursive', survey: @survey)
      expect(survey_q).to be_invalid
    end
  end

  context 'when question_type is missing' do
    it 'should be invalid' do
      survey_q = SurveyQuestion.new(question: 'pergunta teste', survey: @survey)
      expect(survey_q).to be_invalid
    end
  end

  context 'when question_type is outside the possibilities' do
    it 'should be invalid' do
      survey_q = SurveyQuestion.new(question: 'pergunta teste', question_type: 'nao_existe', survey: @survey)
      expect(survey_q).to be_invalid
    end
  end

  context 'when question_type is inside the possibilities' do
      it 'should be valid' do
        survey_q = SurveyQuestion.new(question: 'pergunta teste', question_type: 'discursive', survey: @survey)
        expect(survey_q).to be_valid
      end
  end
    
end
