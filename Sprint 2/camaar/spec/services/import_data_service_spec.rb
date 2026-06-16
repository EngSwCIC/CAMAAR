require 'rails_helper'

RSpec.describe ImportDataService do
  describe '.import_all' do

    let(:classes_path) { Rails.root.join('..', '..', 'classes.json').to_s }
    let(:members_path) { Rails.root.join('..', '..', 'class_members.json').to_s }

    let(:classes_json) { File.read(Rails.root.join('..','..','classes.json')) }
    let(:members_json) { File.read(Rails.root.join('..','..','class_members.json')) }

    before do
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:exist?).and_call_original

      allow(File).to receive(:read).with(classes_path).and_return(classes_json)
      allow(File).to receive(:read).with(members_path).and_return(members_json)
      allow(File).to receive(:exist?).with(classes_path).and_return(true)
      allow(File).to receive(:exist?).with(members_path).and_return(true)
    end

    # ─── Caminho feliz ────────────────────────────────────────────────────────

    context 'quando os arquivos existem' do

      it 'retorna sucesso' do
        result = described_class.import_all

        expect(result[:success]).to be true
      end

      it 'importa disciplinas' do
        described_class.import_all

        disciplina = Disciplina.find_by(codigo: 'CIC0097')

        expect(disciplina).not_to be_nil
        expect(disciplina.nome).to eq('BANCOS DE DADOS')
        expect(disciplina.department).to eq('CIC')
      end

      it 'importa turmas' do
        described_class.import_all

        disciplina = Disciplina.find_by(codigo: 'CIC0097')
        turma = Turma.find_by(
          codigo: 'TA',
          semestre: '2021.2',
          disciplina: disciplina
        )

        expect(turma).not_to be_nil
      end

      it 'importa usuários' do
        described_class.import_all

        expect(User.count).to be > 0
      end

      it 'cria relacionamentos entre alunos e turmas' do
        described_class.import_all

        expect(TurmaAluno.count).to be > 0
      end

      it 'não duplica registros ao importar duas vezes' do
        described_class.import_all

        disciplinas = Disciplina.count
        turmas      = Turma.count
        usuarios    = User.count
        matriculas  = TurmaAluno.count

        described_class.import_all

        expect(Disciplina.count).to eq(disciplinas)
        expect(Turma.count).to eq(turmas)
        expect(User.count).to eq(usuarios)
        expect(TurmaAluno.count).to eq(matriculas)
      end

    end

    # ─── Arquivos ausentes ────────────────────────────────────────────────────

    context 'quando os arquivos não existem' do
      before do
        allow(File).to receive(:exist?).and_call_original

        allow(File).to receive(:exist?) do |path|
          false
        end
      end

      it 'retorna erro' do
        result = described_class.import_all

        expect(result[:success]).to be false
        expect(result[:error]).to eq('Arquivos não localizados')
      end
    end

    # ─── JSON inválido ────────────────────────────────────────────────────────

    context 'quando o JSON é inválido' do

      before do
        allow(File).to receive(:read).and_return('json inválido')
      end

      it 'retorna erro de leitura' do
        result = described_class.import_all

        expect(result[:success]).to be false
        expect(result[:error]).to eq('Erro ao ler os arquivos JSON')
      end

    end

  end
end