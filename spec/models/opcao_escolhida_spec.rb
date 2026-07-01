# frozen_string_literal: true

require "rails_helper"

RSpec.describe OpcaoEscolhida, type: :model do
  let(:questao_objetiva) do
    Questao.new(enunciado: "Escolha", tipo: :objetiva).tap do |questao|
      questao.opcoes.build(numero: 1, texto: "A")
      questao.opcoes.build(numero: 2, texto: "B")
      questao.save!
    end
  end
  let(:outra_questao_objetiva) do
    Questao.new(enunciado: "Outra escolha", tipo: :objetiva).tap do |questao|
      questao.opcoes.build(numero: 1, texto: "C")
      questao.opcoes.build(numero: 2, texto: "D")
      questao.save!
    end
  end
  let(:questao_discursiva) { Questao.create!(enunciado: "Descreva", tipo: :discursiva) }

  it "aceita opção da questão objetiva respondida" do
    resposta = Resposta.new(questao: questao_objetiva)
    opcao_escolhida = described_class.new(resposta: resposta, opcao: questao_objetiva.opcoes.first)

    expect(opcao_escolhida).to be_valid
  end

  it "rejeita opção de outra questão" do
    resposta = Resposta.new(questao: questao_objetiva)
    opcao_escolhida = described_class.new(resposta: resposta, opcao: outra_questao_objetiva.opcoes.first)

    expect(opcao_escolhida).not_to be_valid
    expect(opcao_escolhida.errors[:opcao]).to include("deve pertencer à questão respondida")
  end

  it "rejeita resposta de questão discursiva" do
    resposta = Resposta.new(questao: questao_discursiva)
    opcao_escolhida = described_class.new(resposta: resposta, opcao: questao_objetiva.opcoes.first)

    expect(opcao_escolhida).not_to be_valid
    expect(opcao_escolhida.errors[:resposta]).to include("deve pertencer a uma questão objetiva")
  end

  it "não permite repetir a mesma opção em uma resposta" do
    departamento = Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}")
    admin = create_admin_usuario(departamento: departamento)
    turma = create_turma(nome_materia: "MDS", numero: 1, departamento: departamento)
    discente = create_usuario
    participacao = create_participacao(usuario: discente, turma: turma, tipo_participacao: :discente)
    template = create_template_with_questoes(titulo: "Avaliação", adm: admin.perfil_adm)
    formulario = create_formulario(
      turma: turma,
      adm: admin.perfil_adm,
      template: template,
      publico_alvo: :discentes
    )
    avaliacao = Avaliacao.create!(formulario: formulario, participacao_turma: participacao)
    questao = formulario.questoes.find(&:objetiva?)
    resposta = Resposta.new(avaliacao: avaliacao, questao: questao).tap do |item|
      item.opcoes_escolhidas.build(opcao: questao.opcoes.first)
      item.save!
    end

    duplicada = described_class.new(resposta: resposta, opcao: questao.opcoes.first)

    expect(duplicada).not_to be_valid
    expect(duplicada.errors[:opcao_id]).to include("já foi escolhida nesta resposta")
  end
end
