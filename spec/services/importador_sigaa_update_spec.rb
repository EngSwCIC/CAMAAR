require 'rails_helper'

RSpec.describe ImportadorSigaa, type: :service do
  describe '#processar' do
    let!(:materia_existente) do
      Materia.create!(id: "CIC0001", nome: "OAC")
    end

    let!(:professor_existente) do
      Pessoa.create!(nome: "Lamar", email: "lamar@email.com", matricula: "123", senha: "testeProfessor")
    end

    let!(:aluno_existente) do
      Pessoa.create!(nome: "José", email: "jose@email.com", matricula: "123456789", senha: "testeAluno")
    end

    let!(:turma_existente) do
      Turma.create!(id: 1, id_materia: "CIC0001", numero_turma: 1, semestre: "2024.2", professor: "lamar@email.com")
    end

    let(:json_data) do
      [
        {
          "id" => 1,
          "code" => "CIC0001",
          "classCode" => "1",
          "name" => "ISC",
          "time" => "24T23",
          "semester" => "2025.1",
          "dicente" => [
            {
              "nome" => "José Edson",
              "matricula" => "123456789",
              "usuario" => "jose@email.com",
              "formacao" => "Graduação",
              "ocupacao" => "Estudante",
              "email" => "jose@email.com"
            }
          ],
          "docente" => {
            "nome" => "Prof. Lamar",
            "usuario" => "987654321",
            "formacao" => "Doutorado",
            "ocupacao" => "Docente",
            "email" => "lamar@email.com",
            "departamento" => "CIC"
          }
        }
      ]
    end

    it 'atualiza os dados corretamente quando já existem' do
      expect {
        ImportadorSigaa.new(json_data).processar
      }.not_to change(Materia, :count)

      materia = Materia.find_by(id: "CIC0001")
      expect(materia.nome).to eq("ISC")

      professor = Pessoa.find_by(email: "lamar@email.com")
      expect(professor.nome).to eq("Prof. Lamar")

      aluno = Pessoa.find_by(email: "jose@email.com")
      expect(aluno.nome).to eq("José Edson")

      turma = Turma.find(1)
      expect(turma.semestre).to eq("2025.1")
      expect(turma.professor).to eq("lamar@email.com")
    end
  end
end
