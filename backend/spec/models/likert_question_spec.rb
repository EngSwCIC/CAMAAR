require 'rails_helper'

RSpec.describe LikertQuestion, type: :model do

  before(:all) do
    @survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
    @survey_q = SurveyQuestion.new(question: 'perrgunta', question_type: 'likert_scale', survey: @survey)
    @l_scale = LikertScale.new(survey_question: @survey_q)
  end

  context 'when all attributes is valid' do
    it 'should be valid' do
      l_question = LikertQuestion.new(question: 'pergunta teste', likert_scale: @l_scale)
      expect(l_question).to be_valid
    end
  end

  context 'when question is missing' do
    it 'should be invalid' do
      l_question = LikertQuestion.new(likert_scale: @l_scale)
      expect(l_question).to be_invalid
    end
  end

  context 'when LikertQuesiton is missing' do
    it 'should be invalid' do
      l_question = LikertQuestion.new(question: 'pergunta teste')
      expect(l_question).to be_invalid
    end
  end
    
end
