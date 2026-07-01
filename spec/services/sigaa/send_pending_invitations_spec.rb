# frozen_string_literal: true

require "rails_helper"

RSpec.describe SIGAA::SendPendingInvitations do
  let!(:departamento) { Departamento.create!(nome: "Ciência da Computação") }
  let(:admin) { create_admin_usuario(departamento: departamento, nome: "Coordenação") }

  it "falha sem tentar envio quando o administrador não possui departamento" do
    allow(admin).to receive(:perfil_adm).and_return(nil)

    result = described_class.call(current_user: admin)

    expect(result).to be_missing_department
    expect(result.successes).to eq(0)
  end

  it "retorna vazio quando não há usuários pendentes no departamento" do
    result = described_class.call(current_user: admin)

    expect(result).to be_empty
    expect(result.errors).to be_empty
  end

  it "envia convites para docentes e discentes pendentes do departamento" do
    create_pending_docente
    create_pending_discente
    allow_any_instance_of(described_class).to receive(:enviar_email_convite_admin).and_return(true)

    expect do
      result = described_class.call(current_user: admin)
      expect(result).to be_success
      expect(result.successes).to eq(2)
    end.to change(Token, :count).by(2)
  end

  it "faz rollback do token quando o envio falha para um usuário" do
    docente = create_pending_docente(nome: "Docente Falha", email: "falha@unb.br", matricula: "DOC-FALHA")
    allow_any_instance_of(described_class).to receive(:enviar_email_convite_admin).and_return(false)

    result = described_class.call(current_user: admin)

    expect(result.status).to eq(:partial)
    expect(result.successes).to eq(0)
    expect(result.errors).to include("Docente Falha (Matrícula: DOC-FALHA): Falha de comunicação com a Brevo.")
    expect(docente.tokens.count).to eq(0)
  end

  def create_pending_docente(**attrs)
    create_usuario(**{ nome: "Docente", status: :pendente }.merge(attrs)).tap do |usuario|
      create_perfil_docente(usuario, departamento: departamento)
    end
  end

  def create_pending_discente(**attrs)
    turma = create_turma(nome_materia: "MDS", numero: 1, departamento: departamento)
    create_usuario(**{ nome: "Discente", status: :pendente }.merge(attrs)).tap do |usuario|
      create_participacao(usuario: usuario, turma: turma, tipo_participacao: :discente)
    end
  end
end
