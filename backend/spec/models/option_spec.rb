require 'rails_helper'

RSpec.describe Option, type: :model do
  context 'Checar criação de Opções para o Questionário' do
    it 'Quando a questão associada é do tipo caixa de seleção' do
      @survey = Survey.new(name:"Survey", description:"description", semester:"2021.2")
      @survey_question = SurveyQuestion.new(question_type: 'Caixa de Seleção', question: 'Pergunta', optional: true, survey: @survey)

      option = Option.new(option: "Opção", survey_question: @survey_question)
      expect(option).to be_valid
    end

    it 'Quando a questão associada não é do tipo caixa de seleção' do
      @survey = Survey.new(name:"Survey", description:"description", semester:"2021.2")
      @survey_question = SurveyQuestion.new(question_type: 'Escala', question: 'Pergunta', optional: true, survey: @survey)

      option = Option.new(option: "Opção", survey_question: @survey_question)
      expect(option).to_not be_valid
    end
  end
end
