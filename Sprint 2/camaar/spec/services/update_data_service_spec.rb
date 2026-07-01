require 'rails_helper'

RSpec.describe UpdateDataService do
  describe '.update_all' do

    # Paths que o service usa internamente — ajuste se necessário
    let(:classes_path) { Rails.root.join('..', '..', 'classes.json').to_s }
    let(:members_path) { Rails.root.join('..', '..', 'class_members.json').to_s }

    # Lê os fixtures uma vez (File.read real, antes de qualquer stub)
    let(:classes_json) { File.read(Rails.root.join('..','..','classes.json')) }
    let(:members_json) { File.read(Rails.root.join('..','..','class_members.json')) }

    before do
      # Fallback: qualquer leitura não stubada continua funcionando
      # (Rails internals, bootsnap, i18n, etc. não são afetados)
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:exist?).and_call_original

      # Stubs específicos por path — sem fila, sempre retornam o mesmo valor
      # Funciona independente de quantas vezes import_all + update_all chamarem
      allow(File).to receive(:read).with(classes_path).and_return(classes_json)
      allow(File).to receive(:read).with(members_path).and_return(members_json)
      allow(File).to receive(:exist?).with(classes_path).and_return(true)
      allow(File).to receive(:exist?).with(members_path).and_return(true)
    end

    # ─── Caminho feliz ────────────────────────────────────────────────────────

    context 'quando existem alterações disponíveis' do

      it 'atualiza os dados de um usuário' do
        user = User.create!(
          matricula: '200033522',
          name:      'Nome Antigo',
          email:     'email_antigo@unb.br',
          role:      'user',
          password:  '123456'
        )

        result = described_class.update_all

        expect(result[:success]).to be true

        user.reload
        expect(user.name).not_to eq('Nome Antigo')
        expect(user.email).not_to eq('email_antigo@unb.br')
      end

      it 'atualiza uma disciplina' do
        Disciplina.create!(
          codigo:     'CIC0097',
          nome:       'DISCIPLINA ANTIGA',
          department: 'CIC'
        )

        described_class.update_all

        expect(Disciplina.find_by(codigo: 'CIC0097').nome).to eq('BANCOS DE DADOS')
      end

      it 'atualiza uma turma' do
        disciplina = Disciplina.create!(
          codigo:     'CIC0097',
          nome:       'BANCOS DE DADOS',
          department: 'CIC'
        )

        Turma.create!(
          codigo:     'TA',
          semestre:   '2021.2',
          horario:    '00M12',
          disciplina: disciplina
        )

        described_class.update_all

        turma = Turma.find_by(codigo: 'TA', semestre: '2021.2', disciplina: disciplina)
        expect(turma.horario).to eq('35T45')
      end

      it 'retorna mensagem de sucesso quando houver atualizações' do
        User.create!(
          matricula: '200033522',
          name:      'Nome Antigo',
          email:     'email_antigo@unb.br',
          role:      'user',
          password:  '123456'
        )

        result = described_class.update_all

        expect(result[:success]).to be true
        expect(result[:message]).to eq('Dados atualizados com sucesso')
      end

    end

    # ─── Base já sincronizada ─────────────────────────────────────────────────

    context 'quando a base já está sincronizada' do

      before do
        # import_all consome 2 leituras. Com stubs por path (sem fila),
        # update_all pode ler novamente sem problema.
        ImportDataService.import_all
      end

      it 'não altera registros existentes' do
        result = described_class.update_all

        expect(result[:success]).to be true
        expect(result[:message]).to eq('Não há novos dados para atualização')
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
        result = described_class.update_all

        expect(result[:success]).to be false
        expect(result[:error]).to eq('Arquivos não localizados')
      end

    end

    # ─── JSON inválido ────────────────────────────────────────────────────────

    context 'quando o JSON é inválido' do

      before do
        allow(File).to receive(:read).and_return('json inválido')
      end

      it 'retorna erro ao ler os arquivos JSON' do
        result = described_class.update_all

        expect(result[:success]).to be false
        expect(result[:error]).to eq('Erro ao ler os arquivos JSON')
      end

    end

  end
end