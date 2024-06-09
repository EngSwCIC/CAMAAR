require 'rails_helper'

RSpec.describe Template, type: :model do
  it 'é válido com atributos válidos e FKS existentes' do
    department = create(:department)

      admin = create(:admin)
      coordinator = create(:coordinator)
      template = create(:template)
      template_questions = create(:template_question)

      expect(template).to be_valid
      expect(template_questions).to be_valid

  end

  it 'é inválido sem FKS existentes' do
    template = build(:template)
    expect(template).to_not be_valid
  end
end
