# frozen_string_literal: true

require "rails_helper"

RSpec.describe Avaliacoes::SubmitResponse do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:turma) { create_turma(nome_materia: "Cálculo", numero: 1, departamento: departamento) }
  let(:discente) { create_usuario(nome: "Discente") }
  let!(:participacao) { create_participacao(usuario: discente, turma: turma, tipo_participacao: :discente) }
  let(:template) { create_template_with_questoes(titulo: "Avaliação", adm: admin.perfil_adm) }
  let!(:formulario) do
    create_formulario(
      turma: turma,
      adm: admin.perfil_adm,
      template: template,
      publico_alvo: :discentes,
      criar_avaliacoes: true
    )
  end
  let(:avaliacao) { formulario.avaliacoes.sole }
  let(:questao_discursiva) { formulario.questoes.find(&:discursiva?) }
  let(:questao_objetiva) { formulario.questoes.find(&:objetiva?) }

  it "salva as respostas e marca a avaliação como respondida" do
    expect do
      result = described_class.call(avaliacao: avaliacao, respostas_params: valid_answers)
      expect(result).to be_success
    end.to change(Resposta, :count).by(2)
      .and change(Texto, :count).by(1)
      .and change(OpcaoEscolhida, :count).by(1)

    expect(avaliacao.reload).to be_respondida
  end

  it "retorna inválido quando uma resposta obrigatória está em branco" do
    result = described_class.call(
      avaliacao: avaliacao,
      respostas_params: {
        questao_discursiva.id.to_s => { "texto" => "Comentário" },
        questao_objetiva.id.to_s => { "opcao_id" => "" }
      }
    )

    expect(result.status).to eq(:invalid)
    expect(avaliacao.reload).to be_pendente
    expect(Resposta.count).to eq(0)
  end

  it "não grava novamente quando a avaliação já foi respondida" do
    avaliacao.marcar_como_respondida!

    result = described_class.call(avaliacao: avaliacao, respostas_params: valid_answers)

    expect(result).to be_already_answered
    expect(Resposta.count).to eq(0)
  end

  def valid_answers
    {
      questao_discursiva.id.to_s => { "texto" => "Comentário final" },
      questao_objetiva.id.to_s => { "opcao_id" => questao_objetiva.opcoes.first.id.to_s }
    }
  end
end
