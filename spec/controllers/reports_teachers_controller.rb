require 'rails_helper'

RSpec.describe ReportsProfessorsController, type: :request do
  describe 'GET #index' do
    it 'retorna a lista de reports_professors' do
      get '/reports_professors'
      expect(response).to have_http_status(:success)
      expect(assigns(:reports_professors)).not_to be_nil
    end
  end

  describe 'GET #new' do
    it 'renderiza o formulário para criar um novo relatório de professor' do
      get '/reports_professors/new'
      expect(response).to have_http_status(:success)
      expect(assigns(:reports_professor)).to be_a_new(ReportsProfessor)
    end
  end
end