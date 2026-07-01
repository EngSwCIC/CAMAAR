# frozen_string_literal: true

require "rails_helper"

RSpec.describe Formularios::CSVExport do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:turma) { create_turma(nome_materia: "MDS", numero: 1, departamento: departamento) }
  let(:template) { create_template_with_questoes(titulo: "Avaliação Docente", adm: admin.perfil_adm) }

  it "gera CSV com cabeçalho, respostas registradas e marcações de ausência" do
    discente_texto = create_usuario(nome: "Discente Texto", matricula: "20260001")
    discente_opcao = create_usuario(nome: "Discente Opção", matricula: "20260002")
    participacao_texto = create_participacao(usuario: discente_texto, turma: turma, tipo_participacao: :discente)
    participacao_opcao = create_participacao(usuario: discente_opcao, turma: turma, tipo_participacao: :discente)
    discente_texto.update!(matricula: "20260001")
    discente_opcao.update!(matricula: "20260002")
    formulario = create_formulario(
      turma: turma,
      adm: admin.perfil_adm,
      template: template,
      publico_alvo: :discentes,
      criar_avaliacoes: true
    )
    questao_discursiva = formulario.questoes.find(&:discursiva?)
    questao_objetiva = formulario.questoes.find(&:objetiva?)

    create_text_answer(formulario, participacao_texto, questao_discursiva)
    create_option_answer(formulario, participacao_opcao, questao_objetiva)

    csv = described_class.call(formulario: formulario)
    export = described_class.new(formulario: formulario)

    expect(csv).to include("Aluno;Matrícula;#{questao_discursiva.enunciado};#{questao_objetiva.enunciado}")
    expect(csv).to include("Discente Texto;20260001;Comentário textual;Sem resposta")
    expect(csv).to include("Discente Opção;20260002;Sem resposta;#{questao_objetiva.opcoes.first.texto}")
    expect(export.filename).to include("resultados_turma_#{turma.materia.codigo}")
  end

  def create_text_answer(formulario, participacao, question)
    avaliacao = formulario.avaliacoes.find_by!(participacao_turma: participacao)
    Resposta.new(avaliacao: avaliacao, questao: question).tap do |resposta|
      resposta.build_texto(texto: "Comentário textual")
      resposta.save!
    end
  end

  def create_option_answer(formulario, participacao, question)
    avaliacao = formulario.avaliacoes.find_by!(participacao_turma: participacao)
    Resposta.new(avaliacao: avaliacao, questao: question).tap do |resposta|
      resposta.opcoes_escolhidas.build(opcao: question.opcoes.first)
      resposta.save!
    end
  end
end
