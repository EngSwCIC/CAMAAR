require 'rails_helper'

RSpec.describe "Atualização da Base via SIGAA", type: :request do
  let!(:admin) { Usuario.create!(nome: "Admin", email: "admin@unb.br", matricula: "1", perfil: "administrador", ativo: true, senha_hash: "") }
  let!(:turma_existente) { Turma.create!(codigo_turma: "T1", semestre: "2026.1", departamento: Departamento.find_or_create_by!(nome: "DEPTO CIÊNCIAS DA COMPUTAÇÃO"), disciplina: Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0123")) }
  let!(:aluno) { Usuario.create!(nome: "Aluno Teste", email: "aluno@teste.com", matricula: "111222333", perfil: "discente", senha_hash: "") }
  let!(:matricula) { Matricula.create!(usuario: aluno, turma: turma_existente, papel_na_turma: "aluno") }

  before do
    admin.password = "password123"
    admin.save!
    post login_path, params: { email: admin.email, password: 'password123' }
  end

  describe "POST /admin/sigaa_update" do
    context "Cenário Feliz: Sincronização de vínculos" do
      it "atualiza o status da matrícula para refletir trancamento ou nova alocação no SIGAA" do
        ENV["SIGAA_DATA_STATUS"] = "status_changed"
        post sigaa_update_path
        expect(response).to redirect_to(admin_import_console_path)
        expect(flash[:notice]).to eq("Base de dados atualizada com sucesso")
        ENV["SIGAA_DATA_STATUS"] = nil
      end
    end

    context "Cenários Tristes: Conflitos e Inconsistências" do
      it "inativa o vínculo na turma, mas mantém o registro histórico intacto caso o aluno já tenha respondido um formulário" do
        template = Template.new(titulo: "t", criador_id: admin.id)
        template.perguntas.build(enunciado: "Q", tipo: "dissertativa", ordem: 1)
        template.save!
        form = Formulario.create!(turma: turma_existente, status: "Fechado", criado_por_id: admin.id, publico_alvo: "discente", template: template)
        resposta = Resposta.create!(usuario: aluno, formulario: form, enviado_em: Time.current)

        ENV["SIGAA_DATA_STATUS"] = "missing_aluno"
        post sigaa_update_path
        expect(Resposta.exists?(resposta.id)).to be_truthy
        expect(matricula.reload.papel_na_turma).to eq("inativo")
        ENV["SIGAA_DATA_STATUS"] = nil
      end

      it "aborta a transação (rollback) se o SIGAA enviar dados estruturais corrompidos" do
        ENV["SIGAA_DATA_STATUS"] = "corrupted"
        post sigaa_update_path
        expect(response).to redirect_to(admin_import_console_path)
        expect(flash[:alert]).to include("Erro de compatibilidade de dados. Atualização cancelada.")
        ENV["SIGAA_DATA_STATUS"] = nil
      end

      it "bloqueia uma segunda requisição caso o sistema já esteja processando uma atualização concorrente" do
        ENV["SIGAA_UPDATING_MOCK"] = "true"
        post sigaa_update_path
        expect(response).to redirect_to(admin_import_console_path)
        expect(flash[:alert]).to eq("Uma atualização já está em andamento. Aguarde a conclusão.")
        ENV["SIGAA_UPDATING_MOCK"] = nil
      end

      it "libera a trava infinita quando chamado com ?release_lock=true" do
        ENV["SIGAA_UPDATING_MOCK"] = "true"
        post sigaa_update_path(release_lock: "true")
        expect(response).to redirect_to(admin_import_console_path)
        expect(flash[:notice]).to eq("Trava liberada com sucesso.")
        ENV["SIGAA_UPDATING_MOCK"] = nil
      end
    end
  end
end
