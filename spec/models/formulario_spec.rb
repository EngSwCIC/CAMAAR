require 'rails_helper'

RSpec.describe Formulario, type: :model do
  let(:template) do
    Template.create!(nome: "Avaliação",
                     questions_attributes: [ { enunciado: "Q1?", tipo: "discursiva" } ])
  end
  let(:turma) { Turma.create!(code: "CIC0105", name: "ENG SW", class_code: "TA", semester: "2021.2") }
  let(:aluno) do
    User.create!(nome: "Aluno", email: "aluno@x.com", password: "password123",
                 matricula: "190", perfil: "discente")
  end

  it "exige título" do
    expect(Formulario.new(template: template, turma: turma, titulo: nil)).not_to be_valid
  end

  describe "#respondido_por? e totais" do
    before { Enrollment.create!(user: aluno, turma: turma, role: "discente") }

    it "conta participantes e detecta respostas" do
      formulario = Formulario.create!(template: template, turma: turma, titulo: "Form 1")

      expect(formulario.total_participantes).to eq(1)
      expect(formulario.respondido_por?(aluno)).to be false
      expect(formulario.total_respondentes).to eq(0)

      Resposta.create!(formulario: formulario, user: aluno,
                       question: template.questions.first, valor: "Ótima")

      expect(formulario.respondido_por?(aluno)).to be true
      expect(formulario.total_respondentes).to eq(1)
    end
  end
end
