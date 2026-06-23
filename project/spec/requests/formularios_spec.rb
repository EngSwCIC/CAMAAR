require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  describe "GET /formularios/:id/exportar_csv" do
    it "retorna um arquivo CSV de sucesso com as respostas da avaliação" do
      admin = create(:user, :admin)
      formulario = create(:formulario, admin: admin)

      login_as(admin)
      get exportar_csv_formulario_path(formulario, format: :csv)

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq('text/csv')
      expect(response.body).to include("ID da Pergunta", "Enunciado")
    end
  end

  describe "POST /formularios" do
    it "cria um formulário a partir de um template e clona as questões do template" do
      admin = create(:user, :admin)
      template = create(:template, admin: admin)
      create(:questao, template: template, enunciado: "O professor foi claro?")
      course_class = create(:course_class)

      login_as(admin)
      expect {
        post formularios_path, params: {
          formulario: { title: "Avaliação do Semestre", template_id: template.id, course_class_id: course_class.id }
        }
      }.to change(Formulario, :count).by(1).and change(Questao, :count).by(1)

      expect(response).to redirect_to(formularios_path)
      follow_redirect!
      expect(response.body).to include("Formulário gerado com sucesso!")

      formulario = Formulario.last
      expect(formulario.admin_id).to eq(admin.id)
      expect(formulario.questaos.first.enunciado).to eq("O professor foi claro?")
      expect(formulario.questaos.first.template_id).to be_nil
    end

    it "não cria o formulário quando nenhum template é selecionado" do
      admin = create(:user, :admin)
      course_class = create(:course_class)

      login_as(admin)
      expect {
        post formularios_path, params: {
          formulario: { title: "Sem template", course_class_id: course_class.id }
        }
      }.not_to change(Formulario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("É necessário escolher um template base")
    end

    it "não cria o formulário quando nenhuma turma é selecionada" do
      admin = create(:user, :admin)
      template = create(:template, :com_questao, admin: admin)

      login_as(admin)
      expect {
        post formularios_path, params: {
          formulario: { title: "Sem turma", template_id: template.id }
        }
      }.not_to change(Formulario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("É necessário escolher ao menos uma turma")
    end
  end
end
