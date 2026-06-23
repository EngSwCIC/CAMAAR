require "rails_helper"

RSpec.describe Template, type: :model do
  describe "validações" do
    it "é válido com os atributos da factory" do
      expect(build(:template)).to be_valid
    end

    it "exige um título" do
      template = build(:template, title: "")

      expect(template).not_to be_valid
      expect(template.errors[:title]).to include("O nome do template é obrigatório")
    end
  end

  describe "associações" do
    it "pertence a um admin" do
      template = create(:template)

      expect(template.admin).to be_present
    end

    it "destrói suas questões ao ser destruído (#102)" do
      template = create(:template, :com_questao)

      expect { template.destroy }.to change(Questao, :count).by(-1)
    end

    it "desvincula, mas não destrói, formulários gerados ao ser destruído (#112)" do
      template = create(:template)
      formulario = create(:formulario, template: template)

      expect { template.destroy }.not_to change(Formulario, :count)
      expect(formulario.reload.template_id).to be_nil
    end

    it "não afeta as questões já clonadas para um formulário ao ser destruído (#112)" do
      template = create(:template)
      create(:formulario, :com_questao, template: template)

      expect { template.destroy }.not_to change(Questao, :count)
    end
  end
end
