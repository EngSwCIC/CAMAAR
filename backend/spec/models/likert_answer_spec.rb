require 'rails_helper'

RSpec.describe LikertAnswer, type: :model do

  before(:all) do
    @survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
    @survey_q = SurveyQuestion.new(question: 'pergunta', survey: @survey)
    @likert_s = LikertScale.new(survey_question: @survey_q)
    @likert_q = LikertQuestion.new(question: 'pergunta', likert_scale: @likert_s)
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
    @answer = Answer.new(survey_answer: @s_answer, survey_question: @survey_q)
  end

  context 'when question_type is likert_scale and content is present' do
    it 'should be valid' do
      @survey_q.question_type = 'likert_scale'
      l_answer = LikertAnswer.new(content: 'Concordo totalmente', answer: @answer, likert_question: @likert_q)
      expect(l_answer).to be_valid
    end
  end

  context 'when question_type is discursive and content is missing' do
    it 'should be invalid' do
      @survey_q.question_type = 'likert_scale'
      l_answer = LikertAnswer.new(answer: @answer, likert_question: @likert_q)
      expect(l_answer).to be_invalid
    end
  end

  context 'when question_type is not likert_scale' do
    it 'should be valid' do
      ['discursive', 'multiple_choice'].each do |type|
        @survey_q.question_type = type
        l_answer = LikertAnswer.new(content: 'Concordo totalmente', answer: @answer, likert_question: @likert_q)
        expect(l_answer).to be_valid
      end
    end
  end

  context 'when Answer is missing' do
    it 'should be invalid' do
      l_answer = LikertAnswer.new(content: 'test', likert_question: @likert_q)
      expect(l_answer).to be_invalid
    end
  end
    
  context 'when LikertQuestion is missing' do
    it 'should be invalid' do
      l_answer = LikertAnswer.new(content: 'test', answer: @answer)
      expect(l_answer).to be_invalid
    end
  end

end
