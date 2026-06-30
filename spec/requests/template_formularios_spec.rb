require "rails_helper"

RSpec.describe "TemplateFormularios", type: :request do
  let(:criador) { create(:criador_formulario) }
  let(:admin_u) { criador.usuario }
  let(:template) { create(:template_formulario, criador_formulario: criador) }

  let(:admin_sem_criador) do
    Usuario.create!(nome: "Admin Sem Criador", email: "admin-sc-tplspec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :admin)
  end

  def login_as(usuario)
    post login_path, params: { email: usuario.email, password: "Senha123" }
  end

  def params_pergunta_discursiva(nome_template)
    {
      template_formulario: {
        nome_template: nome_template,
        perguntas_attributes: {
          "0" => { tipo_pergunta: "discursiva", enunciado: "Questão 1?", gabarito_discursiva: "Resposta" }
        }
      }
    }
  end

  describe "GET /template_formularios/:id (show)" do
    it "exibe os detalhes do template para um admin (Happy Path)" do
      login_as(admin_u)
      get template_formulario_path(template)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(template.nome_template)
    end
  end

  describe "GET /template_formularios/new" do
    it "exibe o formulário de criação (Happy Path)" do
      login_as(admin_u)
      get new_template_formulario_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Nome do Template")
    end
  end

  describe "POST /template_formularios" do
    context "com dados válidos e admin com perfil de criador (Happy Path)" do
      it "cria o template e redireciona para edição" do
        login_as(admin_u)
        expect {
          post template_formularios_path, params: params_pergunta_discursiva("Novo Template")
        }.to change(TemplateFormulario, :count).by(1)

        expect(response).to redirect_to(edit_template_formulario_path(TemplateFormulario.last))
        follow_redirect!
        expect(response.body).to include("Template iniciado")
      end
    end

    context "com admin sem perfil de criador (Sad Path)" do
      it "não cria o template e renderiza com erro de perfil" do
        login_as(admin_sem_criador)
        expect {
          post template_formularios_path, params: params_pergunta_discursiva("Template Sem Criador")
        }.not_to change(TemplateFormulario, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Administrador não possui perfil")
      end
    end

    context "com pergunta do tipo radio sem campos obrigatórios (Sad Path)" do
      it "não cria o template e renderiza com erros de validação" do
        login_as(admin_u)
        expect {
          post template_formularios_path, params: {
            template_formulario: {
              nome_template: "Template Inválido",
              perguntas_attributes: {
                "0" => { tipo_pergunta: "radio", enunciado: "Questão?",
                         numero_opcoes: "", gabarito_radio: "" }
              }
            }
          }
        }.not_to change(TemplateFormulario, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /template_formularios/:id/edit" do
    it "exibe o formulário de edição (Happy Path)" do
      login_as(admin_u)
      get edit_template_formulario_path(template)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(template.nome_template)
    end
  end

  describe "PATCH /template_formularios/:id" do
    context "com dados válidos (Happy Path)" do
      it "atualiza o template e redireciona para a lista" do
        login_as(admin_u)
        patch template_formulario_path(template), params: {
          template_formulario: { nome_template: "Nome Atualizado", perguntas_attributes: {} }
        }
        expect(response).to redirect_to(editar_templates_path)
        follow_redirect!
        expect(response.body).to include("Template finalizado")
      end
    end

    context "com pergunta do tipo radio sem campos obrigatórios (Sad Path)" do
      it "não atualiza e renderiza com erros de validação" do
        login_as(admin_u)
        patch template_formulario_path(template), params: {
          template_formulario: {
            nome_template: template.nome_template,
            perguntas_attributes: {
              "0" => { tipo_pergunta: "radio", enunciado: "Questão?",
                       numero_opcoes: "", gabarito_radio: "" }
            }
          }
        }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /template_formularios/:id" do
    it "destrói o template e redireciona para a lista (Happy Path)" do
      template_para_deletar = create(:template_formulario, criador_formulario: criador)
      login_as(admin_u)
      expect {
        delete template_formulario_path(template_para_deletar)
      }.to change(TemplateFormulario, :count).by(-1)

      expect(response).to redirect_to(editar_templates_path)
      follow_redirect!
      expect(response.body).to include("excluída")
    end
  end
end
