require 'rails_helper'
require 'simplecov'
SimpleCov.start

RSpec.describe 'User Management System Integration' do
  describe 'User model functionality' do
    it 'creates different types of users' do
      admin = create(:user, :admin)
      aluno = create(:user, :aluno)
      professor = create(:user, :professor)

      expect(admin.admin?).to be true
      expect(aluno.aluno?).to be true
      expect(professor.professor?).to be true
    end

    it 'validates user data' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'manages user course assignment' do
      user = create(:user, :aluno, curso: 'Engenharia de Software')
      expect(user.curso).to eq('Engenharia de Software')
    end
  end

  describe 'Discipline associations' do
    let(:curso) { create(:curso) }
    let(:disciplina) { create(:disciplina, curso: curso) }
    let(:professor) { create(:user, :professor) }
    let(:aluno) { create(:user, :aluno) }

    it 'associates professor with disciplines' do
      create(:turma, disciplina: disciplina, professor: professor)

      expect(professor.disciplinas_como_professor).to include(disciplina)
      expect(professor.disciplinas.count).to eq(1)
    end

    it 'associates student with disciplines through matriculas' do
      turma = create(:turma, disciplina: disciplina, professor: professor)
      create(:matricula, user: aluno, turma: turma)

      expect(aluno.disciplinas_como_aluno).to include(disciplina)
      expect(aluno.matriculas.count).to eq(1)
    end
  end

  describe 'Authorization system' do
    it 'allows only admins to register new users' do
      admin = create(:user, :admin)
      aluno = create(:user, :aluno)

      expect(User.can_register?(admin)).to be true
      expect(User.can_register?(aluno)).to be false
      expect(User.can_register?(nil)).to be false
    end
  end
end
