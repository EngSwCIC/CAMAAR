require 'rails_helper'

RSpec.describe Admin::FormulariosController, type: :controller do
  render_views

  let(:admin) { create(:pessoa, email: "admin@camaar.com") }

  before do
    session[:email] = admin.email
  end

  describe "POST #create" do
    context "com dados válidos" do
      it "cria um formulário e redireciona" do
        materia = create(:materia)
        turma = create(:turma, materia: materia)

        ligacao = create(:ligacao_pergunta)
        create(:pergunta, ligacao_pergunta: ligacao)
        template = create(:template, ligacao_pergunta: ligacao)

        expect {
          post :create, params: {
            formulario: {
              template_id: template.id,
              materia_ids: [materia.id]
            }
          }
        }.to change(Formulario, :count).by(1)

        expect(response).to redirect_to(admin_gerenciamento_path)
        expect(flash[:notice]).to eq("Formulário enviado com sucesso")
      end
    end

    context "sem template selecionado" do
      it "não cria formulário e renderiza :new com erro" do
        materia = create(:materia)
        create(:turma, materia: materia)

        post :create, params: {
          formulario: {
            template_id: nil,
            materia_ids: [materia.id]
          }
        }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq("Nenhum template selecionado")
      end
    end

    context "sem matéria selecionada" do
      it "não cria formulário e renderiza :new com erro" do
        ligacao = create(:ligacao_pergunta)
        create(:pergunta, ligacao_pergunta: ligacao)
        template = create(:template, ligacao_pergunta: ligacao)

        post :create, params: {
          formulario: {
            template_id: template.id,
            materia_ids: []
          }
        }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq("Nenhuma matéria foi selecionada")
      end
    end
  end
end
