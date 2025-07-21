require 'rails_helper'

RSpec.describe ImportadorSigaa, type: :service do
  describe '#processar' do
    let(:json_data) do
      [
        {
          "id" => 1,
          "code" => "CIC0001",
          "classCode" => "1",
          "name" => "OAC",
          "time" => "24T23",
          "semester" => "2025.1",
          "dicente" => [
            {
              "nome" => "José",
              "matricula" => "987654321",
              "usuario" => "jose@email.com",
              "formacao" => "Graduação",
              "ocupacao" => "Estudante",
              "email" => "jose@email.com"
            }
          ],
          "docente" => {
            "nome" => "Prof. Lamar",
            "usuario" => "lamar@email.com",
            "formacao" => "Doutorado",
            "ocupacao" => "Docente",
            "email" => "lamar@email.com",
            "departamento" => "CIC"
          }
        }
      ]
    end

    it 'importa todos os dados corretamente' do
      expect {
        ImportadorSigaa.new(json_data).processar
      }.to change(Materia, :count).by(1)
       .and change(Turma, :count).by(1)
       .and change(Pessoa, :count).by(2)
       .and change(Cargo, :count).by(2)
       .and change(Participante, :count).by(1)

      materia = Materia.find_by(id: "CIC0001")
      expect(materia.nome).to eq("OAC")

      professor = Pessoa.find_by(email: "lamar@email.com")
      expect(professor.nome).to eq("Prof. Lamar")

      aluno = Pessoa.find_by(email: "jose@email.com")
      expect(aluno.nome).to eq("José")

      turma = Turma.find(1)
      expect(turma.semestre).to eq("2025.1")
      expect(turma.professor).to eq("lamar@email.com")

      participante = Participante.find_by(email: "jose@email.com", id_turma: turma.id)
      expect(participante).to be_present
    end
  end
end
