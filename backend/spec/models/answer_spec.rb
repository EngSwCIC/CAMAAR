require 'rails_helper'

RSpec.describe Answer, type: :model do

  before(:all) do
    @survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
    @survey_q = SurveyQuestion.new(question: 'pergunta', survey: @survey)
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
    @s_answer = SurveyAnswer.new(survey: @survey, cclass: @cclass, member: @member)
  end

  context 'when question_type is discursive and content is present' do
    it 'should be valid' do
      @survey_q.question_type = 'discursive'
      answer = Answer.new(content: 'resposta', survey_question: @survey_q, survey_answer: @s_answer)
      expect(answer).to be_valid
    end
  end

  context 'when question_type is discursive and content is missing' do
    it 'should be invalid' do
      @survey_q.question_type = 'discursive'
      answer = Answer.new(survey_question: @survey_q, survey_answer: @s_answer)
      expect(answer).to be_invalid
    end
  end

  context 'when question_type is multiple_choice and content is present' do
    it 'should be valid' do
      @survey_q.question_type = 'multiple_choice'
      answer = Answer.new(content: 'resposta', survey_question: @survey_q, survey_answer: @s_answer)
      expect(answer).to be_valid
    end
  end

  context 'when question_type is multiple_choice and content is missing' do
    it 'should be invalid' do
      @survey_q.question_type = 'multiple_choice'
      answer = Answer.new(survey_question: @survey_q, survey_answer: @s_answer)
      expect(answer).to be_invalid
    end
  end

  context 'when SurveyQuestion is missing' do
    it 'should be invalid' do
      answer = Answer.new(survey_answer: @s_answer)
      expect(answer).to be_invalid
    end
  end
    
  context 'when SurveyAnswer is missing' do
    it 'should be invalid' do
      answer = Answer.new(survey_question: @survey_q)
      expect(answer).to be_invalid
    end
  end

end
