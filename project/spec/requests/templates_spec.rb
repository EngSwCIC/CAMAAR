require "rails_helper"

RSpec.describe "Templates", type: :request do
  describe "POST /templates" do
    it "cria um template com uma questão e redireciona para a lista de templates" do
      admin = create(:user, :admin)
      login_as(admin)

      expect {
        post templates_path, params: {
          template: {
            title: "Avaliação de Disciplina",
            target_role: "discente",
            questaos: { "0" => { enunciado: "O conteúdo foi claro?", tipo: "rating" } }
          }
        }
      }.to change(Template, :count).by(1).and change(Questao, :count).by(1)

      expect(response).to redirect_to(templates_path)

      template = Template.last
      expect(template.title).to eq("Avaliação de Disciplina")
      expect(template.admin_id).to eq(admin.id)
      expect(template.questaos.first.enunciado).to eq("O conteúdo foi claro?")
    end

    it "não cria o template e exibe erro quando o nome está em branco" do
      admin = create(:user, :admin)
      login_as(admin)

      expect {
        post templates_path, params: {
          template: {
            title: "",
            target_role: "discente",
            questaos: { "0" => { enunciado: "Pergunta válida", tipo: "rating" } }
          }
        }
      }.not_to change(Template, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("O nome do template é obrigatório")
    end

    it "não cria o template e exibe erro quando a questão não possui enunciado" do
      admin = create(:user, :admin)
      login_as(admin)

      expect {
        post templates_path, params: {
          template: {
            title: "Avaliação sem enunciado",
            target_role: "discente",
            questaos: { "0" => { enunciado: "", tipo: "rating" } }
          }
        }
      }.not_to change(Template, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Questão não possui enunciado")
    end

    it "adiciona um novo campo de questão sem persistir nada ao clicar em '+'" do
      admin = create(:user, :admin)
      login_as(admin)
      template_count_before = Template.count
      questao_count_before = Questao.count

      post templates_path, params: {
        add_questao: "+",
        template: { title: "Rascunho", target_role: "discente" }
      }

      expect(response).to have_http_status(:ok)
      expect(Template.count).to eq(template_count_before)
      expect(Questao.count).to eq(questao_count_before)
      expect(response.body).to include("template[questaos][0][enunciado]")
    end
  end

  describe "GET /templates" do
    it "lista apenas os templates do administrador autenticado" do
      admin = create(:user, :admin)
      outro_admin = create(:user, :admin)

      meu_template = create(:template, :com_questao, admin: admin, title: "Meu Template")
      create(:template, :com_questao, admin: outro_admin, title: "Template de Outro Admin")

      login_as(admin)
      get templates_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(meu_template.title)
      expect(response.body).not_to include("Template de Outro Admin")
    end
  end

  describe "GET /templates/:id/edit" do
    it "bloqueia o acesso a um template de outro administrador" do
      admin = create(:user, :admin)
      outro_admin = create(:user, :admin)
      template_outro_admin = create(:template, :com_questao, admin: outro_admin)

      login_as(admin)
      get edit_template_path(template_outro_admin)

      expect(response).to redirect_to(templates_path)
      follow_redirect!
      expect(response.body).to include("Você não tem acesso a esse template")
    end
  end

  describe "PATCH /templates/:id" do
    it "atualiza o template sem afetar as questões dos formulários já gerados a partir dele" do
      admin = create(:user, :admin)
      template = create(:template, admin: admin)
      create(:questao, template: template, enunciado: "Pergunta original")
      course_class = create(:course_class)

      formulario = create(:formulario, admin: admin, template: template, course_class: course_class, title: "Formulário Gerado", target_role: template.target_role)
      template.questaos.each { |questao| formulario.questaos.create!(enunciado: questao.enunciado, tipo: questao.tipo) }

      questao_existente = template.questaos.first

      login_as(admin)
      patch template_path(template), params: {
        template: {
          title: "Título atualizado",
          target_role: template.target_role,
          questaos: { "0" => { id: questao_existente.id, enunciado: questao_existente.enunciado, tipo: questao_existente.tipo } }
        }
      }

      expect(response).to redirect_to(templates_path)
      expect(template.reload.title).to eq("Título atualizado")

      formulario.reload
      expect(formulario.questaos.first.enunciado).to eq("Pergunta original")
      expect(formulario.questaos.first.template_id).to be_nil
    end

    it "exige enunciado para novas questões adicionadas durante a edição" do
      admin = create(:user, :admin)
      template = create(:template, :com_questao, admin: admin)
      questao_existente = template.questaos.first

      login_as(admin)
      patch template_path(template), params: {
        template: {
          title: template.title,
          target_role: template.target_role,
          questaos: {
            "0" => { id: questao_existente.id, enunciado: questao_existente.enunciado, tipo: questao_existente.tipo },
            "1" => { enunciado: "", tipo: "rating" }
          }
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("A nova questão não possui enunciado")
    end
  end

  describe "GET /templates/:id" do
    it "exibe o template do administrador autenticado" do
      admin = create(:user, :admin)
      template = create(:template, :com_questao, admin: admin)

      login_as(admin)
      get template_path(template)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /templates/:id com add_questao" do
    it "adiciona campo de questao sem persistir ao clicar em '+' durante edicao" do
      admin = create(:user, :admin)
      template = create(:template, :com_questao, admin: admin)
      questao_existente = template.questaos.first

      login_as(admin)
      patch template_path(template), params: {
        add_questao: "+",
        template: {
          title: template.title,
          target_role: template.target_role,
          questaos: { "0" => { id: questao_existente.id, enunciado: questao_existente.enunciado, tipo: questao_existente.tipo } }
        }
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("template[questaos][1][enunciado]")
    end
  end

  describe "DELETE /templates/:id" do
    it "remove o template, desvincula formulários gerados e mantém suas questões clonadas" do
      admin = create(:user, :admin)
      template = create(:template, :com_questao, admin: admin)
      course_class = create(:course_class)

      formulario = create(:formulario, admin: admin, template: template, course_class: course_class, title: "Formulário Gerado", target_role: template.target_role)
      template.questaos.each { |questao| formulario.questaos.create!(enunciado: questao.enunciado, tipo: questao.tipo) }

      login_as(admin)
      expect {
        delete template_path(template)
      }.to change(Template, :count).by(-1)

      expect(response).to redirect_to(templates_path)

      formulario.reload
      expect(formulario.template_id).to be_nil
      expect(formulario.questaos.count).to eq(1)
    end
  end
end
