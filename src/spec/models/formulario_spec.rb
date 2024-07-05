# spec/models/formulario_spec.rb

require 'rails_helper'

RSpec.describe Formulario, type: :model do
  describe "attributes" do
    it { should respond_to(:template_id) }
    it { should respond_to(:turma_id) }
    it { should respond_to(:respostas) }
  end

  describe "validations" do
    let(:template) { Template.create(nome: "Template 1") }
    let(:turma) { Turma.create(id_professor: 1, materia_id: 1) }

    it "is valid with valid attributes" do
      formulario = Formulario.new(template: template, turma: turma)
      expect(formulario).to be_valid
    end

    it "is not valid without a template" do
      formulario = Formulario.new(turma: turma)
      expect(formulario).not_to be_valid
    end

    it "is not valid without a turma" do
      formulario = Formulario.new(template: template)
      expect(formulario).not_to be_valid
    end
  end
end
