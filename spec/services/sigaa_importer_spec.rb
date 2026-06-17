require 'rails_helper'

RSpec.describe SigaaImporter do
  describe '.import_classes' do
    let(:json_content) do
      [
        {
          "code": "CIC0105",
          "name": "ENGENHARIA DE SOFTWARE",
          "class": {
            "classCode": "TA",
            "semester": "2021.2",
            "time": "35M12"
          }
        }
      ].to_json
    end

    it 'creates a new disciplina and turma' do
      expect {
        SigaaImporter.import_classes(json_content)
      }.to change(Disciplina, :count).by(1)
       .and change(Turma, :count).by(1)
      
      disciplina = Disciplina.find_by(code: 'CIC0105')
      expect(disciplina.name).to eq('ENGENHARIA DE SOFTWARE')
      
      turma = Turma.find_by(classCode: 'TA', disciplina: disciplina)
      expect(turma.semester).to eq('2021.2')
    end

    it 'returns success message' do
      result = SigaaImporter.import_classes(json_content)
      expect(result[:success]).to be true
      expect(result[:message]).to include("Dados de turmas importados com sucesso")
    end

    it 'returns error for invalid JSON' do
      result = SigaaImporter.import_classes("invalid json")
      expect(result[:success]).to be false
      expect(result[:message]).to include("Erro na estrutura do arquivo")
    end
  end

  describe '.import_members' do
    let!(:disciplina) { Disciplina.create!(code: 'CIC0097', name: 'BANCOS DE DADOS') }
    let!(:turma) { Turma.create!(classCode: 'TA', semester: '2021.2', disciplina: disciplina) }
    
    let(:json_content) do
      [
        {
          "code": "CIC0097",
          "classCode": "TA",
          "semester": "2021.2",
          "dicente": [
            {
              "nome": "ANA CLARA",
              "matricula": "20210001",
              "email": "ana@teste.com"
            }
          ],
          "docente": {
            "nome": "DR. TESTE",
            "usuario": "docente01",
            "email": "docente@teste.com"
          }
        }
      ].to_json
    end

    it 'creates discente and docente records' do
      expect {
        SigaaImporter.import_members(json_content)
      }.to change(Discente, :count).by(1)
       .and change(Docente, :count).by(1)
    end

    it 'creates user records for discentes and docentes' do
      expect {
        SigaaImporter.import_members(json_content)
      }.to change(User, :count).by(2)
      
      expect(User.find_by(matricula: '20210001').role).to eq('discente')
      expect(User.find_by(matricula: 'docente01').role).to eq('docente')
    end

    it 'associates discente with the correct turma' do
      SigaaImporter.import_members(json_content)
      discente = Discente.find_by(matricula: '20210001')
      expect(discente.turma).to eq(turma)
    end

    it 'returns success message' do
      result = SigaaImporter.import_members(json_content)
      expect(result[:success]).to be true
      expect(result[:message]).to eq("Participantes importados com sucesso")
    end

    it 'returns error for invalid JSON' do
      result = SigaaImporter.import_members("invalid json")
      expect(result[:success]).to be false
      expect(result[:message]).to include("Erro na estrutura do arquivo")
    end
  end
end
