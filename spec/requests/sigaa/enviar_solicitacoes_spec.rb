# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard - Enviar Solicitações de Cadastro", type: :request do
  let!(:departamento) { Departamento.create!(nome: "Ciência da Computação") }
  let!(:admin_user) do
    Usuario.create!(
      nome: "Coordenação de Computação",
      email: "admin_cic@unb.br",
      matricula: "999999999",
      senha: "SenhaSegura123",
      senha_confirmation: "SenhaSegura123",
      status: 1
    )
  end
  let!(:perfil_adm) { PerfilAdm.create!(usuario: admin_user, departamento: departamento) }

  before do
    allow(admin_user).to receive(:administrador?).and_return(true)
    allow_any_instance_of(DashboardController).to receive(:current_user).and_return(admin_user)
  end

  describe "POST /dashboard/enviar_solicitacoes" do
    context "quando o filtro 'verificar_admin' barra o acesso" do
      before do
        allow(admin_user).to receive(:administrador?).and_return(false)
      end

      it "limpa a sessão e redireciona o intruso para a raiz com mensagem restrita" do
        post enviar_solicitacoes_path

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("Acesso restrito. Por favor, faça login como administrador.")
      end
    end

    context "quando o administrador não possui um departamento associado" do
      before do
        allow(admin_user).to receive(:perfil_adm).and_return(nil)
      end

      it "redireciona para a tela de gerenciamento exibindo o erro de associação" do
        post enviar_solicitacoes_path

        expect(response).to redirect_to(gerenciamento_path)
        expect(flash[:error]).to eq("Seu usuário não possui um departamento associado.")
      end
    end

    context "quando não há nenhum usuário pendente no departamento" do
      it "redireciona informando que a lista de pendências está limpa" do
        post enviar_solicitacoes_path

        expect(response).to redirect_to(gerenciamento_path)
        expect(flash[:notice]).to eq("Não há usuários pendentes de cadastro (docentes ou discentes) neste departamento.")
      end
    end

    context "quando existem usuários pendentes de cadastro (status = 0)" do
      let!(:docente_pendente) do
        Usuario.create!(
          nome: "Professor Substituto",
          email: "docente_teste@unb.br",
          matricula: "202611111",
          senha: "SenhaTemporaria1",
          senha_confirmation: "SenhaTemporaria1",
          status: 0
        )
      end

      let!(:discente_pendente) do
        Usuario.create!(
          nome: "Aluno Voluntário",
          email: "discente_teste@unb.br",
          matricula: "202622222",
          senha: "SenhaTemporaria2",
          senha_confirmation: "SenhaTemporaria2",
          status: 0
        )
      end

      before do
        PerfilDocente.create!(usuario: docente_pendente, departamento: departamento)
        materia = Materia.create!(nome: "Estruturas de Dados", codigo: "CIC0001", departamento_id: departamento.id)
        turma = Turma.create!(materia: materia, numero: 1, ano: 2026, semestre: 1)
        PerfilDiscente.create!(usuario: discente_pendente)
        ParticipacaoTurma.create!(usuario: discente_pendente, turma: turma, tipo_participacao: :discente)
      end

      context "e todos os envios de e-mail ocorrem perfeitamente" do
        before do
          allow_any_instance_of(SIGAA::SendPendingInvitations)
            .to receive(:enviar_email_convite_admin)
            .and_return(true)
        end

        it "gera um token de cadastro para cada um e redireciona com mensagem de total sucesso" do
          expect {
            post enviar_solicitacoes_path
          }.to change(Token, :count).by(2)

          expect(response).to redirect_to(gerenciamento_path)
          expect(flash[:success]).to eq("Convites enviados com sucesso para os <strong>2</strong> usuários pendentes do departamento!")
          expect(docente_pendente.tokens.last.tipo).to eq("cadastro")
          expect(discente_pendente.tokens.last.tipo).to eq("cadastro")
        end
      end

      context "e o serviço de e-mail falha ao processar algum usuário" do
        before do
          allow_any_instance_of(SIGAA::SendPendingInvitations).to receive(:enviar_email_convite_admin) do |_, email, _, _|
            email == "discente_teste@unb.br"
          end
        end

        it "executa o rollback do token que falhou e anexa o log detalhado no flash" do
          post enviar_solicitacoes_path

          expect(response).to redirect_to(gerenciamento_path)
          expect(flash[:error]).to eq("O envio foi concluído com instabilidades. Foram enviados 1 e-mails.")
          expect(flash[:error_list]).to include("Professor Substituto (Matrícula: 202611111): Falha de comunicação com a Brevo.")
          expect(discente_pendente.tokens.count).to eq(1)
          expect(docente_pendente.tokens.count).to eq(0)
        end
      end
    end
  end
end
