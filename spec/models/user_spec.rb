# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'validates presence of name' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of matricula' do
      user = build(:user, matricula: nil)
      expect(user).not_to be_valid
      expect(user.errors[:matricula]).to include("can't be blank")
    end

    it 'validates uniqueness of matricula' do
      create(:user, matricula: '12345')
      user = build(:user, matricula: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:matricula]).to include('has already been taken')
    end

    it 'validates presence of role' do
      user = build(:user, role: nil)
      expect(user).not_to be_valid
    end

    it 'validates length of curso' do
      user = build(:user, curso: 'a' * 256)
      expect(user).not_to be_valid
      expect(user.errors[:curso]).to include('is too long (maximum is 255 characters)')
    end

    it 'validates length of departamento' do
      user = build(:user, departamento: 'a' * 256)
      expect(user).not_to be_valid
      expect(user.errors[:departamento]).to include('is too long (maximum is 255 characters)')
    end

    it 'allows blank departamento' do
      user = build(:user, departamento: '')
      expect(user).to be_valid
    end

    it 'validates length of formacao' do
      user = build(:user, formacao: 'a' * 101)
      expect(user).not_to be_valid
      expect(user.errors[:formacao]).to include('is too long (maximum is 100 characters)')
    end

    it 'allows blank formacao' do
      user = build(:user, formacao: '')
      expect(user).to be_valid
    end
  end

  describe 'enums' do
    it 'defines correct roles' do
      expect(described_class.roles).to eq({ 'admin' => 0, 'aluno' => 1, 'professor' => 2, 'coordenador' => 3 })
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:templates).dependent(:destroy) }
    it { is_expected.to have_many(:formularios).dependent(:destroy) }
    it { is_expected.to have_many(:turmas).dependent(:destroy) }
    it { is_expected.to have_many(:matriculas).dependent(:destroy) }
    it { is_expected.to have_many(:submissoes_concluidas).dependent(:destroy) }

    # Associações específicas para professores
    it { is_expected.to have_many(:turmas_como_professor).dependent(:destroy) }
    it { is_expected.to have_many(:disciplinas_como_professor) }

    # Associações específicas para alunos
    it { is_expected.to have_many(:turmas_matriculadas) }
    it { is_expected.to have_many(:disciplinas_como_aluno) }
  end

  describe 'callbacks' do
    it 'downcases email before save' do
      user = build(:user, email: 'TEST@EXAMPLE.COM')
      user.save
      expect(user.email).to eq('test@example.com')
    end

    it 'does not downcase nil email' do
      user = build(:user, email: nil)
      expect { user.save }.not_to raise_error
    end

    it 'does not change already downcased email' do
      user = build(:user, email: 'test@example.com')
      user.save
      expect(user.email).to eq('test@example.com')
    end
  end

  describe '.can_register?' do
    context 'when current user is admin' do
      let(:admin) { create(:user, :admin) }

      it 'returns true' do
        expect(described_class.can_register?(admin)).to be true
      end
    end

    context 'when current user is not admin' do
      let(:aluno) { create(:user, :aluno) }

      it 'returns false' do
        expect(described_class.can_register?(aluno)).to be false
      end
    end

    context 'when no current user' do
      it 'returns false' do
        expect(described_class.can_register?(nil)).to be false
      end
    end
  end

  describe '#disciplinas' do
    let(:curso) { create(:curso) }
    let(:disciplina1) { create(:disciplina, curso: curso) } # rubocop:disable RSpec/IndexedLet
    let(:disciplina2) { create(:disciplina, curso: curso) } # rubocop:disable RSpec/IndexedLet

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }

      it 'returns all disciplinas' do
        disciplina1
        disciplina2
        expect(admin.disciplinas).to include(disciplina1, disciplina2)
      end
    end

    context 'when user is professor' do
      let(:professor) { create(:user, :professor) }
      let!(:turma) { create(:turma, disciplina: disciplina1, professor: professor) }

      it 'returns only disciplinas they teach' do
        expect(professor.disciplinas).to include(disciplina1)
        expect(professor.disciplinas).not_to include(disciplina2)
      end
    end

    context 'when user is aluno' do
      let(:aluno) { create(:user, :aluno) }
      let(:professor) { create(:user, :professor) }
      let!(:turma) { create(:turma, disciplina: disciplina1, professor: professor) }
      let!(:matricula) { create(:matricula, user: aluno, turma: turma) }

      it 'returns only disciplinas they are enrolled in' do
        expect(aluno.disciplinas).to include(disciplina1)
        expect(aluno.disciplinas).not_to include(disciplina2)
      end
    end

    context 'when user has coordenador role' do
      let(:coordenador) { create(:user, :coordenador) }

      it 'returns no disciplinas' do
        disciplina1
        disciplina2
        expect(coordenador.disciplinas).to eq(Disciplina.none)
      end
    end

    context 'when user has unknown role' do
      let(:user) { create(:user, :aluno) }

      before do
        allow(user).to receive(:role).and_return('unknown_role')
      end

      it 'returns no disciplinas' do
        disciplina1
        disciplina2
        expect(user.disciplinas).to eq(Disciplina.none)
      end
    end
  end

  describe 'role methods' do
    it 'correctly identifies admin role' do
      admin = create(:user, :admin)
      expect(admin.admin?).to be true
      expect(admin.aluno?).to be false
    end

    it 'correctly identifies aluno role' do
      aluno = create(:user, :aluno)
      expect(aluno.aluno?).to be true
      expect(aluno.admin?).to be false
    end

    it 'correctly identifies professor role' do
      professor = create(:user, :professor)
      expect(professor.professor?).to be true
      expect(professor.admin?).to be false
    end

    it 'correctly identifies coordenador role' do
      coordenador = create(:user, :coordenador)
      expect(coordenador.coordenador?).to be true
      expect(coordenador.admin?).to be false
    end
  end

  describe '#leciona_disciplina?' do
    let(:curso) { create(:curso) }
    let(:disciplina) { create(:disciplina, curso: curso) }
    let(:outra_disciplina) { create(:disciplina, curso: curso) }

    context 'when user is professor' do
      let(:professor) { create(:user, :professor) }
      let!(:turma) { create(:turma, disciplina: disciplina, professor: professor) }

      it 'returns true for disciplina they teach' do
        expect(professor.leciona_disciplina?(disciplina.id)).to be true
      end

      it 'returns false for disciplina they do not teach' do
        expect(professor.leciona_disciplina?(outra_disciplina.id)).to be false
      end
    end

    context 'when user is not professor' do
      let(:aluno) { create(:user, :aluno) }

      it 'returns false regardless of disciplina' do
        expect(aluno.leciona_disciplina?(disciplina.id)).to be false
      end
    end
  end

  describe '#matriculado_em_disciplina?' do
    let(:curso) { create(:curso) }
    let(:disciplina) { create(:disciplina, curso: curso) }
    let(:outra_disciplina) { create(:disciplina, curso: curso) }
    let(:professor) { create(:user, :professor) }

    context 'when user is aluno' do
      let(:aluno) { create(:user, :aluno) }
      let!(:turma) { create(:turma, disciplina: disciplina, professor: professor) }
      let!(:matricula) { create(:matricula, user: aluno, turma: turma) }

      it 'returns true for disciplina they are enrolled in' do
        expect(aluno.matriculado_em_disciplina?(disciplina.id)).to be true
      end

      it 'returns false for disciplina they are not enrolled in' do
        expect(aluno.matriculado_em_disciplina?(outra_disciplina.id)).to be false
      end
    end

    context 'when user is not aluno' do
      let(:admin) { create(:user, :admin) }

      it 'returns false regardless of disciplina' do
        expect(admin.matriculado_em_disciplina?(disciplina.id)).to be false
      end
    end
  end

  describe '#matriculado_em_turma?' do
    let(:curso) { create(:curso) }
    let(:disciplina) { create(:disciplina, curso: curso) }
    let(:professor) { create(:user, :professor) }
    let!(:turma) { create(:turma, disciplina: disciplina, professor: professor) }
    let!(:outra_turma) { create(:turma, disciplina: disciplina, professor: professor) }

    context 'when user is aluno' do
      let(:aluno) { create(:user, :aluno) }
      let!(:matricula) { create(:matricula, user: aluno, turma: turma) }

      it 'returns true for turma they are enrolled in' do
        expect(aluno.matriculado_em_turma?(turma.id)).to be true
      end

      it 'returns false for turma they are not enrolled in' do
        expect(aluno.matriculado_em_turma?(outra_turma.id)).to be false
      end
    end

    context 'when user is not aluno' do
      let(:professor_user) { create(:user, :professor) }

      it 'returns false regardless of turma' do
        expect(professor_user.matriculado_em_turma?(turma.id)).to be false
      end
    end
  end

  describe '#sem_senha?' do
    context 'when user has encrypted password' do
      let(:user) { create(:user, password: 'password123') }

      it 'returns false' do
        expect(user.sem_senha?).to be false
      end
    end

    context 'when user has no encrypted password' do
      let(:user) { build(:user) }

      before do
        user.encrypted_password = ''
        user.save(validate: false)
      end

      it 'returns true' do
        expect(user.sem_senha?).to be true
      end
    end

    context 'when user has nil encrypted password' do
      let(:user) { build(:user) }

      before do
        # Skip validation to test the method logic
        allow(user).to receive(:encrypted_password).and_return(nil)
      end

      it 'returns true' do
        expect(user.sem_senha?).to be true
      end
    end
  end

  describe '#definir_primeira_senha' do
    let(:user) { build(:user) }

    before do
      user.encrypted_password = ''
      user.save(validate: false)
    end

    context 'when user has no password' do
      context 'with valid matching passwords' do
        it 'sets the password successfully' do
          result = user.definir_primeira_senha('newpassword123', 'newpassword123')
          expect(result).to be true
          expect(user.reload.sem_senha?).to be false
        end
      end

      context 'with non-matching passwords' do
        it 'returns false and does not set password' do
          result = user.definir_primeira_senha('newpassword123', 'differentpassword')
          expect(result).to be false
          expect(user.reload.sem_senha?).to be true
        end
      end

      context 'with password too short' do
        it 'returns false and does not set password' do
          result = user.definir_primeira_senha('123', '123')
          expect(result).to be false
          expect(user.reload.sem_senha?).to be true
        end
      end
    end

    context 'when user already has password' do
      let(:user_with_password) { create(:user, password: 'existingpassword', password_confirmation: 'existingpassword') }

      it 'returns false and does not change password' do
        original_encrypted_password = user_with_password.encrypted_password
        result = user_with_password.definir_primeira_senha('newpassword123', 'newpassword123')
        expect(result).to be false
        expect(user_with_password.reload.encrypted_password).to eq(original_encrypted_password)
      end
    end
  end

  describe 'devise modules' do
    it 'includes required devise modules' do
      expect(User.devise_modules).to include(:database_authenticatable, :registerable, :recoverable, :rememberable, :validatable)
    end
  end

  describe 'dependent destroy' do
    let(:user) { create(:user, :admin) }
    let!(:template) { create(:template, criado_por: user) }

    it 'destroys associated records when user is destroyed' do
      expect { user.destroy }.to change(Template, :count).by(-1)
    end
  end
end
