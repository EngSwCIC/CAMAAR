require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  describe "GET /formularios/:id/exportar_csv" do
    it "retorna um arquivo CSV com as respostas estruturadas por questão" do
      admin = create(:user, :admin)
      formulario = create(:formulario, admin: admin)
      questao = create(:questao, :de_formulario, formulario: formulario, tipo: "rating", enunciado: "O professor foi claro?")
      submissao = create(:submissao, formulario: formulario)
      create(:respostum, :numerica, submissao: submissao, questao: questao, valor_numerico: 4)

      login_as(admin)
      get exportar_csv_formulario_path(formulario, format: :csv)

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq('text/csv')
      expect(response.body).to include("ID da Pergunta", "Enunciado")
      expect(response.body).to include("O professor foi claro?")
      expect(response.body).to include("4/5")
    end
  end

  describe "GET /formularios/new" do
    it "exibe o formulário de criação para admin autenticado" do
      admin = create(:user, :admin)
      login_as(admin)
      get new_formulario_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /formularios/:id" do
    it "exibe formulário para participante sem dados de submissões" do
      user = create(:user)
      formulario = create(:formulario)

      login_as(user)
      get formulario_path(formulario)

      expect(response).to have_http_status(:success)
    end

    it "exibe para o administrador as perguntas e as respectivas respostas recebidas" do
      admin = create(:user, :admin)
      formulario = create(:formulario, admin: admin)
      questao = create(:questao, :de_formulario, formulario: formulario, tipo: "text", enunciado: "Comentários?")
      respondente = create(:user, name: "Carla Mendes")
      submissao = create(:submissao, formulario: formulario, user: respondente)
      create(:respostum, submissao: submissao, questao: questao, valor_texto: "Tudo certo")

      login_as(admin)
      get formulario_path(formulario)

      expect(response.body).to include("Comentários?")
      expect(response.body).to include("Carla Mendes")
      expect(response.body).to include("Tudo certo")
    end
  end

  describe "GET /formularios" do
    it "lista apenas formulários cujo público-alvo corresponde ao papel do usuário na turma" do
      turma = create(:course_class)
      user = create(:user)
      create(:class_membership, user: user, course_class: turma, role: :discente)

      formulario_discente = create(:formulario, course_class: turma, target_role: "discente", title: "Avaliação Discente")
      formulario_docente = create(:formulario, course_class: turma, target_role: "docente", title: "Autoavaliação Docente")

      login_as(user)
      get formularios_path

      expect(response.body).to include(formulario_discente.title)
      expect(response.body).not_to include(formulario_docente.title)
    end
  end

  describe "DELETE /formularios/:id" do
    it "remove o formulário" do
      admin = create(:user, :admin)
      formulario = create(:formulario, admin: admin)

      login_as(admin)
      expect {
        delete formulario_path(formulario)
      }.to change(Formulario, :count).by(-1)

      expect(response).to redirect_to(formularios_path)
    end

    it "bloqueia a remoção de um formulário de outro administrador" do
      outro_admin = create(:user, :admin)
      formulario = create(:formulario, admin: outro_admin)

      login_as(create(:user, :admin))
      expect {
        delete formulario_path(formulario)
      }.not_to change(Formulario, :count)

      expect(response).to redirect_to(formularios_path)
    end

    it "remove em cascata questões, submissões e respostas associadas, sem violar chaves estrangeiras" do
      admin = create(:user, :admin)
      formulario = create(:formulario, admin: admin)
      questao = create(:questao, :de_formulario, formulario: formulario)
      submissao = create(:submissao, formulario: formulario)
      create(:respostum, submissao: submissao, questao: questao)

      login_as(admin)
      expect {
        delete formulario_path(formulario)
      }.to change(Formulario, :count).by(-1)
        .and change(Questao, :count).by(-1)
        .and change(Submissao, :count).by(-1)
        .and change(Respostum, :count).by(-1)

      expect(response).to redirect_to(formularios_path)
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
