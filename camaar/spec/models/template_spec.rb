require 'rails_helper'

RSpec.describe Template, type: :model do
  it 'é válido com atributos válidos e FKS existentes' do
    department = create(:department, :departament1)
    admin = create(:admin, :admin1)
    coordinator = create(:coordinator, :coordinator1)
    template = create(:template, :template1)
    template_questions = create(:template_question, :template_question1)
    expect(template).to be_valid
    expect(template_questions).to be_valid
  end

  it 'é inválido sem FKS existentes' do
    template = build(:template, :template1)
    expect(template).to_not be_valid
  end
end
