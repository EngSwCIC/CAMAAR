require 'rails_helper'

RSpec.describe Option, type: :model do

  before(:all) do
    @survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
    @survey_q = SurveyQuestion.new(question: 'perrgunta', question_type: 'likert_scale', survey: @survey)
    @m_choice = MultipleChoice.new(survey_question: @survey_q)
  end

  context 'when all attributes is valid' do
    it 'should be valid' do
      option = Option.new(option: 'opção teste', multiple_choice: @m_choice)
      expect(option).to be_valid
    end
  end

  context 'when option is missing' do
    it 'should be invalid' do
      option = Option.new(multiple_choice: @m_choice)
      expect(option).to be_invalid
    end
  end

  context 'when MultipleChoice is missing' do
    it 'should be invalid' do
      option = Option.new(option: 'opção teste')
      expect(option).to be_invalid
    end
  end
    
end
