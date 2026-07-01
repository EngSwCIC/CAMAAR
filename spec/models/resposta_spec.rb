# frozen_string_literal: true

require "rails_helper"

RSpec.describe Resposta, type: :model do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:turma) { create_turma(nome_materia: "MDS", numero: 1, departamento: departamento) }
  let(:discente) { create_usuario }
  let(:participacao) { create_participacao(usuario: discente, turma: turma, tipo_participacao: :discente) }
  let(:template) { create_template_with_questoes(titulo: "Avaliação", adm: admin.perfil_adm) }
  let(:formulario) do
    create_formulario(
      turma: turma,
      adm: admin.perfil_adm,
      template: template,
      publico_alvo: :discentes
    )
  end
  let(:avaliacao) { Avaliacao.create!(formulario: formulario, participacao_turma: participacao) }
  let(:questao_discursiva) { formulario.questoes.find(&:discursiva?) }
  let(:questao_objetiva) { formulario.questoes.find(&:objetiva?) }

  it "aceita resposta discursiva com texto" do
    resposta = described_class.new(avaliacao: avaliacao, questao: questao_discursiva)
    resposta.build_texto(texto: "  Boa experiência  ")

    expect(resposta).to be_valid
  end

  it "aceita resposta objetiva com opção escolhida" do
    resposta = described_class.new(avaliacao: avaliacao, questao: questao_objetiva)
    resposta.opcoes_escolhidas.build(opcao: questao_objetiva.opcoes.first)

    expect(resposta).to be_valid
  end

  it "exige texto para questão discursiva" do
    resposta = described_class.new(avaliacao: avaliacao, questao: questao_discursiva)

    expect(resposta).not_to be_valid
    expect(resposta.errors[:texto]).to include("deve ser informado")
  end

  it "rejeita opções escolhidas em questão discursiva" do
    resposta = described_class.new(avaliacao: avaliacao, questao: questao_discursiva)
    resposta.build_texto(texto: "Comentário")
    resposta.opcoes_escolhidas.build(opcao: questao_objetiva.opcoes.first)

    expect(resposta).not_to be_valid
    expect(resposta.errors[:opcoes_escolhidas])
      .to include("não devem ser informadas em questão discursiva")
  end

  it "exige opção escolhida para questão objetiva" do
    resposta = described_class.new(avaliacao: avaliacao, questao: questao_objetiva)

    expect(resposta).not_to be_valid
    expect(resposta.errors[:opcoes_escolhidas]).to include("devem ser informadas")
  end

  it "rejeita texto em questão objetiva" do
    resposta = described_class.new(avaliacao: avaliacao, questao: questao_objetiva)
    resposta.build_texto(texto: "Texto indevido")
    resposta.opcoes_escolhidas.build(opcao: questao_objetiva.opcoes.first)

    expect(resposta).not_to be_valid
    expect(resposta.errors[:texto]).to include("não deve ser informado em questão objetiva")
  end

  it "rejeita questão fora do template do formulário" do
    outra_questao = Questao.create!(enunciado: "Questão externa", tipo: :discursiva)
    resposta = described_class.new(avaliacao: avaliacao, questao: outra_questao)
    resposta.build_texto(texto: "Resposta")

    expect(resposta).not_to be_valid
    expect(resposta.errors[:questao]).to include("não pertence ao formulário")
  end

  it "não permite responder a mesma questão duas vezes na avaliação" do
    described_class.new(avaliacao: avaliacao, questao: questao_discursiva).tap do |resposta|
      resposta.build_texto(texto: "Primeira resposta")
      resposta.save!
    end

    duplicada = described_class.new(avaliacao: avaliacao, questao: questao_discursiva)
    duplicada.build_texto(texto: "Segunda resposta")

    expect(duplicada).not_to be_valid
    expect(duplicada.errors[:questao_id]).to include("já foi respondida nesta avaliação")
  end
end
