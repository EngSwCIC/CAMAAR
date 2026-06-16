require 'rails_helper'

RSpec.describe Turma, type: :model do
  def discente(matricula, email)
    User.create!(nome: "Aluno #{matricula}", email: email, password: "password123",
                 matricula: matricula, perfil: "discente")
  end

  describe "validações" do
    it "é válido com os campos obrigatórios" do
      turma = Turma.new(code: "CIC0105", name: "ENG SW", class_code: "TA", semester: "2021.2")
      expect(turma).to be_valid
    end

    it "é inválido sem code" do
      turma = Turma.new(name: "ENG SW", class_code: "TA", semester: "2021.2")
      expect(turma).not_to be_valid
    end

    it "não permite duplicar code/turma/semestre" do
      attrs = { code: "CIC0105", name: "ENG SW", class_code: "TA", semester: "2021.2" }
      Turma.create!(attrs)
      expect(Turma.new(attrs)).not_to be_valid
    end
  end

  describe "#discentes" do
    it "retorna apenas os usuários matriculados como discente" do
      turma = Turma.create!(code: "CIC0105", name: "ENG SW", class_code: "TA", semester: "2021.2")
      aluno = discente("190", "aluno@x.com")
      prof  = User.create!(nome: "Prof", email: "prof@x.com", password: "password123",
                           matricula: "100", perfil: "docente")
      Enrollment.create!(user: aluno, turma: turma, role: "discente")
      Enrollment.create!(user: prof, turma: turma, role: "docente")

      expect(turma.discentes).to contain_exactly(aluno)
    end
  end

  describe "#nome_completo" do
    it "monta uma identificação amigável" do
      turma = Turma.new(code: "CIC0105", name: "ENG SW", class_code: "TA", semester: "2021.2")
      expect(turma.nome_completo).to eq("CIC0105 - ENG SW (TA - 2021.2)")
    end
  end
end
