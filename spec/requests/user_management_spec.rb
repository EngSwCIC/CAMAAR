# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Management', type: :request do
  let(:admin) { create(:user, :admin) }

  describe 'User CRUD operations' do
    before do
      sign_in admin
    end

    it 'shows the users index page' do
      get users_path
      expect(response).to have_http_status(:success)
    end

    it 'shows a specific user' do
      user = create(:user, :aluno)
      get user_path(user)
      expect(response).to have_http_status(:success)
    end

    it 'allows creating a new user' do
      user_params = {
        user: {
          name: 'Test User',
          email: 'test@example.com',
          matricula: '12345678',
          password: 'password123',
          password_confirmation: 'password123',
          role: 'aluno'
        }
      }

      expect do
        post users_path, params: user_params
      end.to change(User, :count).by(1)
    end
  end

  describe 'Discipline management' do
    let(:curso) { create(:curso) }
    let(:disciplina) { create(:disciplina, curso: curso) }
    let(:aluno) { create(:user, :aluno) }
    let(:professor) { create(:user, :professor) }

    before do
      sign_in admin
    end

    it 'adds discipline to student' do
      turma = create(:turma, disciplina: disciplina, professor: professor)

      expect do
        post adicionar_disciplina_aluno_path, params: {
          user_id: aluno.id,
          disciplina_id: disciplina.id,
          turma_id: turma.id
        }
      end.to change { aluno.matriculas.count }.by(1)
    end
  end
end
