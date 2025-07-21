require 'rails_helper'

RSpec.describe Admin::TemplatesController, type: :controller do
  let(:admin) { create(:pessoa, email: "admin@camaar.com", ) }

  before do
    session[:email] = admin.email
    get :index
  end

  describe "GET #index" do
    context "com templates válidos e inválidos" do
      let!(:templates_validos) do
        3.times.map do |i|
          ligacao = create(:ligacao_pergunta)
          create(:pergunta, ligacao_pergunta: ligacao)
          create(:template, nome: "Template #{i+1}", ligacao_pergunta: ligacao)
        end
      end

      let!(:templates_invalidos) do
        2.times.map do |i|
          ligacao = create(:ligacao_pergunta) # sem perguntas
          create(:template, nome: "Inválido #{i+1}", ligacao_pergunta: ligacao)
        end
      end

      it "atribui apenas os templates válidos" do
        get :index
        expect(assigns(:valid_templates)).to match_array(templates_validos)
        expect(assigns(:valid_templates)).not_to include(*templates_invalidos)
      end

      it "define o alerta se houver templates inválidos" do
        get :index
        expect(assigns(:show_incompatibility_message)).to be(true)


      end

      it "renderiza a view de index" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "sem templates inválidos" do
      before do
        # Apenas templates válidos
        2.times do |i|
          ligacao = create(:ligacao_pergunta)
          create(:pergunta, ligacao_pergunta: ligacao)
          create(:template, nome: "Template #{i+1}", ligacao_pergunta: ligacao)
        end
      end

      it "não define flash de alerta" do
        get :index
       expect(assigns(:show_incompatibility_message)).to be(false)
      end
    end
  end
end
