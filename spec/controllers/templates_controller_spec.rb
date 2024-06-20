require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  describe 'POST #save_template' do
    let(:valid_template_params) do
      {
        template: {
          templateName: 'eng_software',
          questions: [
            { type: 'text', options: [] },
            { type: 'checkbox', options: ['teste1', 'teste2'] }
          ]
        }
      }
    end

    it 'salva um novo template com sucesso' do
      post :save_template, params: valid_template_params
      expect(response).to have_http_status(:success)
      expect(response.body).to eq('Template salvo com sucesso!')
      expect(File.exist?(Rails.root.join('public', 'templates', 'eng_software.json'))).to be true
    end
  end

end