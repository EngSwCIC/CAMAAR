require 'rails_helper'

RSpec.describe "Admin::ImportacoesSigaa", type: :request do
  describe "POST /admin/importacoes_sigaa" do
    context "quando o usuário é um Administrador logado" do
      before do
        Usuario.create!(nome: "Admin", email: "admin@unb.br", matricula: "admin", perfil: "administrador", senha_hash: BCrypt::Password.create("123"), ativo: true)
        post login_path, params: { email: "admin@unb.br", password: "123" }
      end

      it "importa os dados do semestre atual com sucesso criando novas disciplinas e turmas" do
        post carregar_dados_teste_path
        expect(response).to redirect_to(admin_dashboard_path)
        expect(flash[:notice]).to eq("Importação concluída com sucesso")
        expect(Disciplina.count).to be > 0
        expect(Turma.count).to be > 0
      end

      it "interrompe a criação de registros específicos se campos obrigatórios estiverem ausentes no pacote de dados" do
        post carregar_dados_teste_path, params: { sigaa_data: "missing_codes" }
        expect(response).to redirect_to(admin_dashboard_path)
        expect(flash[:alert]).to eq("Falha na importação: Códigos de disciplina ausentes")
        expect(Disciplina.count).to eq(0)
      end

      it "cancela a operação se houver falha de conexão ou indisponibilidade no servidor do SIGAA" do
        post carregar_dados_teste_path, params: { sigaa_api_status: "offline" }
        expect(response).to redirect_to(admin_dashboard_path)
        expect(flash[:alert]).to eq("Erro de conexão com o SIGAA. Tente novamente mais tarde.")
        expect(Disciplina.count).to eq(0)
      end

      it "não altera a base de dados atual se o conjunto de dados para importação for vazio" do
        post carregar_dados_teste_path, params: { semestre: "futuro" }
        expect(response).to redirect_to(admin_dashboard_path)
        expect(flash[:alert]).to eq("Nenhum dado novo encontrado para importação neste período.")
        expect(Disciplina.count).to eq(0)
      end
    end

    context "quando o usuário é Docente ou Discente" do
      it "bloqueia o acesso e redireciona para a página inicial" do
        # Simular login de usuário não admin
        user = Usuario.create!(nome: "Docente", email: "doc@unb.br", matricula: "doc", perfil: "docente", senha_hash: BCrypt::Password.create("123"), ativo: true)
        post login_path, params: { email: "doc@unb.br", password: "123" }

        post carregar_dados_teste_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Acesso negado. Esta área é restrita para administradores.")
      end
    end
  end
end
