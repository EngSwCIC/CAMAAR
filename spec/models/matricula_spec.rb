require 'rails_helper'

RSpec.describe Matricula, type: :model do
  let(:user) { create(:user, role: :aluno) }
  let(:turma) { create(:turma) }
  let(:matricula) { build(:matricula, user: user, turma: turma) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:turma) }
    it { should have_one(:disciplina).through(:turma) }
  end

  describe 'validations' do
    describe 'situacao validation' do
      it 'accepts valid situacao values' do
        %w[matriculado aprovado reprovado].each do |status|
          matricula = build(:matricula, user: user, turma: turma, situacao: status)
          expect(matricula).to be_valid
        end
      end

      it 'accepts nil situacao (will be set by callback)' do
        matricula = build(:matricula, user: user, turma: turma, situacao: nil)
        expect(matricula).to be_valid
        matricula.valid?
        expect(matricula.situacao).to eq('matriculado')
      end

      it 'rejects empty string situacao' do
        matricula = build(:matricula, user: user, turma: turma, situacao: '')
        expect(matricula).not_to be_valid
        expect(matricula.errors[:situacao]).to include('is not included in the list')
      end
    end

    describe 'uniqueness validation' do
      it 'validates uniqueness of user_id scoped to turma_id' do
        create(:matricula, user: user, turma: turma)
        duplicate_matricula = build(:matricula, user: user, turma: turma)
        
        expect(duplicate_matricula).not_to be_valid
        expect(duplicate_matricula.errors[:user_id]).to include('já está matriculado nesta turma')
      end

      it 'allows same user in different turmas' do
        turma2 = create(:turma)
        create(:matricula, user: user, turma: turma)
        matricula2 = build(:matricula, user: user, turma: turma2)
        
        expect(matricula2).to be_valid
      end

      it 'allows different users in same turma' do
        user2 = create(:user, role: :aluno)
        create(:matricula, user: user, turma: turma)
        matricula2 = build(:matricula, user: user2, turma: turma)
        
        expect(matricula2).to be_valid
      end
    end
  end

  describe 'callbacks' do
    describe 'before_validation :set_default_situacao' do
      it 'sets default situacao to matriculado when not provided' do
        matricula.situacao = nil
        matricula.valid?
        expect(matricula.situacao).to eq('matriculado')
      end

      it 'does not override existing situacao' do
        matricula.situacao = 'aprovado'
        matricula.valid?
        expect(matricula.situacao).to eq('aprovado')
      end

      it 'handles empty string situacao by leaving it (validation will catch it)' do
        matricula.situacao = ''
        matricula.valid?
        expect(matricula.situacao).to eq('')
        expect(matricula).not_to be_valid
      end

      it 'handles whitespace-only situacao by leaving it (validation will catch it)' do
        matricula.situacao = '   '
        matricula.valid?
        expect(matricula.situacao).to eq('   ')
        expect(matricula).not_to be_valid
      end
    end
  end

  describe 'instance methods' do
    describe '#aluno' do
      context 'when user is aluno' do
        let(:aluno_user) { create(:user, role: :aluno) }
        let(:matricula) { create(:matricula, user: aluno_user, turma: turma) }

        it 'returns the user' do
          expect(matricula.aluno).to eq(aluno_user)
        end
      end

      context 'when user is not aluno' do
        let(:admin_user) { create(:user, role: :admin) }
        let(:matricula) { create(:matricula, user: admin_user, turma: turma) }

        it 'returns nil' do
          expect(matricula.aluno).to be_nil
        end
      end

      context 'when user is professor' do
        let(:professor_user) { create(:user, role: :professor) }
        let(:matricula) { create(:matricula, user: professor_user, turma: turma) }

        it 'returns nil' do
          expect(matricula.aluno).to be_nil
        end
      end

      context 'when user is coordenador' do
        let(:coordenador_user) { create(:user, role: :coordenador) }
        let(:matricula) { create(:matricula, user: coordenador_user, turma: turma) }

        it 'returns nil' do
          expect(matricula.aluno).to be_nil
        end
      end

      context 'when user is nil' do
        it 'returns nil without error' do
          matricula.user = nil
          expect(matricula.aluno).to be_nil
        end
      end
    end
  end

  describe 'edge cases and error handling' do
    it 'handles nil user gracefully' do
      matricula.user = nil
      expect(matricula).not_to be_valid
      expect(matricula.errors[:user]).to include("must exist")
    end

    it 'handles nil turma gracefully' do
      matricula.turma = nil
      expect(matricula).not_to be_valid
      expect(matricula.errors[:turma]).to include("must exist")
    end

    it 'handles invalid user_id' do
      matricula.user_id = 99999
      expect(matricula).not_to be_valid
      expect(matricula.errors[:user]).to include("must exist")
    end

    it 'handles invalid turma_id' do
      matricula.turma_id = 99999
      expect(matricula).not_to be_valid
      expect(matricula.errors[:turma]).to include("must exist")
    end

    it 'handles case sensitivity in situacao' do
      matricula.situacao = 'MATRICULADO'
      expect(matricula).not_to be_valid
      expect(matricula.errors[:situacao]).to include('is not included in the list')
    end

    it 'handles unicode characters in situacao' do
      matricula.situacao = 'matriculadó'
      expect(matricula).not_to be_valid
      expect(matricula.errors[:situacao]).to include('is not included in the list')
    end
  end

  describe 'database constraints and performance' do
    it 'creates matricula successfully with valid data' do
      expect { matricula.save! }.not_to raise_error
      expect(matricula).to be_persisted
    end

    it 'handles concurrent creation attempts gracefully' do
      # Simulate concurrent creation
      matricula1 = build(:matricula, user: user, turma: turma)
      matricula2 = build(:matricula, user: user, turma: turma)
      
      matricula1.save!
      expect { matricula2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'updates situacao successfully' do
      matricula.save!
      expect { matricula.update!(situacao: 'aprovado') }.not_to raise_error
      expect(matricula.reload.situacao).to eq('aprovado')
    end

    it 'destroys matricula successfully' do
      matricula.save!
      expect { matricula.destroy! }.not_to raise_error
    end
  end

  describe 'integration with related models' do
    it 'accesses disciplina through turma association' do
      disciplina = create(:disciplina)
      turma_with_disciplina = create(:turma, disciplina: disciplina)
      matricula_with_disciplina = create(:matricula, user: user, turma: turma_with_disciplina)
      
      expect(matricula_with_disciplina.disciplina).to eq(disciplina)
    end

    it 'handles destroyed user gracefully' do
      matricula.save!
      user_id = matricula.user_id
      
      expect { matricula.user.destroy! }.not_to raise_error
      expect { matricula.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles destroyed turma gracefully' do
      matricula.save!
      turma_id = matricula.turma_id
      
      expect { matricula.turma.destroy! }.not_to raise_error
      expect { matricula.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'complex scenarios' do
    it 'handles multiple situacao changes' do
      matricula.save!
      
      expect { matricula.update!(situacao: 'aprovado') }.not_to raise_error
      expect { matricula.update!(situacao: 'reprovado') }.not_to raise_error
      expect { matricula.update!(situacao: 'matriculado') }.not_to raise_error
      
      expect(matricula.reload.situacao).to eq('matriculado')
    end

    it 'validates uniqueness after user or turma changes' do
      user2 = create(:user, role: :aluno)
      turma2 = create(:turma)
      
      matricula.save!
      matricula2 = create(:matricula, user: user2, turma: turma2)
      
      # Trying to change to same user/turma combination should fail
      expect { matricula2.update!(user: user, turma: turma) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'handles bulk operations' do
      users = create_list(:user, 5, role: :aluno)
      turmas = create_list(:turma, 3)
      
      matriculas = []
      users.each do |u|
        turmas.each do |t|
          matriculas << create(:matricula, user: u, turma: t)
        end
      end
      
      expect(matriculas.count).to eq(15)
      expect(Matricula.count).to eq(15)
    end

    it 'handles situacao statistics' do
      users = create_list(:user, 10, role: :aluno)
      situacoes = %w[matriculado aprovado reprovado]
      
      users.each_with_index do |u, index|
        situacao = situacoes[index % 3]
        create(:matricula, user: u, turma: turma, situacao: situacao)
      end
      
      matriculados = Matricula.where(situacao: 'matriculado').count
      aprovados = Matricula.where(situacao: 'aprovado').count
      reprovados = Matricula.where(situacao: 'reprovado').count
      
      expect(matriculados + aprovados + reprovados).to eq(10)
    end
  end
end
