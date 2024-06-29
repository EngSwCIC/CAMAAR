require 'rails_helper'

RSpec.describe ProfessorsController, type: :controller do
  describe 'GET #dashboard' do
    context 'quando o professor é admin' do
      it 'redireciona para a edição do primeiro template' do
        professor = FactoryBot.create(:professor, isadmin: true)
        sign_in professor
        templates = FactoryBot.create_list(:formulario_template, 3)
        get :dashboard
        expect(response).to redirect_to(edit_template_path(templates.first))
      end
    end

    context 'quando o professor não está autenticado' do
      it 'redireciona para a página de login' do
        get :dashboard  # Faz a requisição GET para o método dashboard sem estar autenticado

        expect(response).to redirect_to(new_professor_session_path)  # Verifica o redirecionamento para a página de login
      end
    end
  end
end