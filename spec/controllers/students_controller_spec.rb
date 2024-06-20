require 'rails_helper'

RSpec.describe AlunosController, type: :controller do
  describe 'GET #dashboard' do
    context 'quando o aluno está autenticado' do
      it 'redireciona para reports_alunos_path' do
        aluno = FactoryBot.create(:aluno)
        sign_in aluno
        get :dashboard
        expect(response).to redirect_to(reports_alunos_path)
      end
    end

    context 'quando o aluno não está autenticado' do
      it 'redireciona para a página de login' do
        get :dashboard
        expect(response).to redirect_to(new_aluno_session_path)
      end
    end
  end
end