require 'rails_helper'

RSpec.describe LikertScale, type: :model do
  before(:all) do
    @survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
  end

  before(:each) do
    @survey_q = SurveyQuestion.new(question: 'pergunta', question_type: 'likert_scale', survey: @survey)
  end

  context 'when SurveyQuestion is present and of correct type' do
    it 'should be valid' do
      l_scale = LikertScale.new(survey_question: @survey_q)
      expect(l_scale).to be_valid
    end
  end

  context 'when SurveyQuestion is present but of incorrect type' do
    it 'should be invalid' do
      @survey_q.question_type = 'invalid_type'
      l_scale = LikertScale.new(survey_question: @survey_q)
      expect(l_scale).to be_invalid
    end
  end

  context 'when SurveyQuestion is missing' do
    it 'should be invalid' do
      l_scale = LikertScale.new()
      expect(l_scale).to be_invalid
    end
  end

end
