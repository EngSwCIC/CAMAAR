require 'rails_helper'

RSpec.describe SurveyAnswer, type: :model do

  before(:all) do
    @survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
    @member = Member.new(
      name: 'teste',
      registration: 'teste',
      username: 'teste',
      occupation: 'dicente',
      degree: 'graduando',
      course: 'teset',
      email: 'email@email.com',
    )
    @cclass = Cclass.new(code: 'TA', semester: '2021/2', time: '35T45')
  end

  context 'when all attributes is valid' do
    it 'should be valid' do
      s_answer = SurveyAnswer.new(survey: @survey, cclass: @cclass, member: @member)
      expect(s_answer).to be_valid
    end
  end

  context 'when Survey is missing' do
    it 'should be invalid' do
      s_answer = SurveyAnswer.new(cclass: @cclass, member: @member)
      expect(s_answer).to be_invalid
    end
  end
    
  context 'when Cclass is missing' do
    it 'should be invalid' do
      s_answer = SurveyAnswer.new(survey: @survey, member: @member)
      expect(s_answer).to be_invalid
    end
  end

  context 'when Member is missing' do
    it 'should be invalid' do
      s_answer = SurveyAnswer.new(survey: @survey, cclass: @cclass)
      expect(s_answer).to be_invalid
    end
  end

end
