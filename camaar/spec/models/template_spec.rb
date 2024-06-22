require 'rails_helper'

RSpec.describe Template, type: :model do
  describe "para que seja válido" do
    it "deve ser válido :)" do
      template = create(:template)
      expect(template).to be_valid
    end

    it "deve possuir um nome" do
      templateB = build(:template, nome: nil)
      expect(templateB).to_not be_valid
    end
  end

  describe "para ter relações válidas" do
    it "pode ter vários formulários" do
      template = Template.reflect_on_association(:formularios)
      expect(template.macro).to eq(:has_many)
    end

    it "pode ter várias questões" do
      template = Template.reflect_on_association(:questaos)
      expect(template.macro).to eq(:has_many)
    end
  end
end
