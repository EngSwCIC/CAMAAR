require 'rails_helper'

RSpec.describe Survey, type: :model do
  context 'Checar criação de Questionários' do
    it 'Quandos os dados são preenchidos corretamente' do
      survey = Survey.new(name:"Survey", description:"description", semester:"2021.2")
      expect(survey).to be_valid
    end

    it 'Quandos o formato do semestre é inválido' do
      survey = Survey.new(name:"Survey", description:"description", semester:"20212")
      expect(survey).to_not be_valid
    end
  end
end
