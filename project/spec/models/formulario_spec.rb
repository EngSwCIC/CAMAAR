require "rails_helper"

RSpec.describe Formulario, type: :model do
  describe "validações" do
    it "é válido e persistido com os atributos da factory" do
      expect(create(:formulario)).to be_persisted
    end

    it "exige um título" do
      formulario = build(:formulario, title: "")

      expect(formulario).not_to be_valid
      expect(formulario.errors[:title]).to include("O nome do formulário é obrigatório")
    end

    it "exige um template ao ser criado (#103)" do
      formulario = build(:formulario, template: nil)

      expect(formulario).not_to be_valid
      expect(formulario.errors[:template_id]).to include("É necessário escolher um template base")
    end

    it "exige uma turma ao ser criado (#103)" do
      formulario = build(:formulario, course_class: nil)

      expect(formulario).not_to be_valid
      expect(formulario.errors[:course_class_id]).to include("É necessário escolher ao menos uma turma")
    end

    it "não exige template nem turma em atualizações (#112)" do
      formulario = create(:formulario)

      formulario.template_id = nil
      formulario.course_class_id = nil

      expect(formulario).to be_valid
    end
  end

  describe "valores padrão" do
    it "define status como 'draft' quando não informado" do
      expect(Formulario.new.status).to eq("draft")
    end

    it "não sobrescreve o status quando já informado" do
      formulario = Formulario.new(status: "concluido")

      expect(formulario.status).to eq("concluido")
    end
  end

  describe "associações" do
    it "pertence a um admin, um template e uma turma" do
      formulario = create(:formulario)

      expect(formulario.admin).to be_present
      expect(formulario.template).to be_present
      expect(formulario.course_class).to be_present
    end

    it "destrói suas próprias questões (clonadas do template) ao ser destruído" do
      formulario = create(:formulario, :com_questao)

      expect { formulario.destroy }.to change(Questao, :count).by(-1)
    end
  end
end
