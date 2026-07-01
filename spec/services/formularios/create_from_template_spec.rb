# frozen_string_literal: true

require "rails_helper"

RSpec.describe Formularios::CreateFromTemplate do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:perfil_adm) { admin.perfil_adm }
  let(:template) { create_template_with_questoes(titulo: "Avaliação Docente", adm: perfil_adm) }
  let(:turma_a) { create_turma(nome_materia: "MDS", numero: 1, departamento: departamento) }
  let(:turma_b) { create_turma(nome_materia: "IHC", numero: 2, departamento: departamento) }
  let(:publico_alvo) { :docentes }

  def call_service(**overrides)
    described_class.call(
      template_id: template.id,
      turma_ids: [ turma_a.id, turma_b.id ],
      publico_alvo: publico_alvo,
      perfil_adm: perfil_adm,
      **overrides
    )
  end

  describe ".call" do
    it "cria um formulário por turma selecionada" do
      formularios = call_service

      expect(formularios.size).to eq(2)
      expect(Formulario.count).to eq(2)
      expect(turma_a.reload.formularios.sole).to eq(formularios.first)
      expect(turma_b.reload.formularios.sole).to eq(formularios.second)
    end

    it "copia as questões do template como snapshot independente" do
      formularios = call_service(turma_ids: [ turma_a.id ])

      formulario = formularios.first
      questoes_template = questoes_ordenadas_do_template(template)
      questoes_formulario = formulario.questoes.order(:id)

      expect(questoes_formulario.count).to eq(questoes_template.count)
      expect(questoes_formulario.pluck(:enunciado)).to eq(questoes_template.map(&:enunciado))
      expect(questoes_formulario.pluck(:tipo)).to eq(questoes_template.map(&:tipo))

      questao_template = questoes_template.first
      questao_formulario = questoes_formulario.first
      enunciado_original = questao_formulario.enunciado

      questao_template.update!(enunciado: "Enunciado alterado no template")

      expect(questao_formulario.reload.enunciado).to eq(enunciado_original)
    end

    it "copia opções para questões objetivas" do
      formularios = call_service(turma_ids: [ turma_a.id ])

      questao_objetiva = formularios.first.questoes.find_by(tipo: :objetiva)
      expect(questao_objetiva.opcoes.order(:numero).pluck(:texto)).to eq(%w[Ruim Regular Boa Excelente])
    end

    it "faz rollback se a criação de um formulário falhar" do
      call_count = 0

      allow(Formulario).to receive(:create!).and_wrap_original do |method, **args|
        call_count += 1
        raise ActiveRecord::RecordInvalid.new(Formulario.new) if call_count == 2

        method.call(**args)
      end

      expect do
        call_service
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect(Formulario.count).to eq(0)
      expect(turma_a.reload.formularios).to be_empty
      expect(turma_b.reload.formularios).to be_empty
    end

    it "levanta erro quando nenhuma turma é selecionada" do
      expect do
        call_service(turma_ids: [])
      end.to raise_error(Formularios::Error, "É necessário selecionar pelo menos uma turma")

      expect(Formulario.count).to eq(0)
    end

    it "levanta erro quando turma já possui formulário para o mesmo template e público-alvo" do
      call_service(turma_ids: [ turma_a.id ])

      expect do
        call_service(turma_ids: [ turma_a.id ])
      end.to raise_error(
        Formularios::Error,
        "Uma ou mais turmas selecionadas já possuem formulário para este template e público-alvo"
      )
    end

    it "permite criar outro formulário com o mesmo template para público-alvo diferente" do
      call_service(turma_ids: [ turma_a.id ], publico_alvo: :docentes)

      expect do
        call_service(turma_ids: [ turma_a.id ], publico_alvo: :discentes)
      end.not_to raise_error

      expect(turma_a.reload.formularios.count).to eq(2)
      expect(turma_a.formularios.pluck(:template_id)).to eq([ template.id, template.id ])
    end

    it "permite criar formulário com template diferente para a mesma turma e público-alvo" do
      outro_template = create_template_with_questoes(titulo: "Outro Template", adm: perfil_adm)
      call_service(turma_ids: [ turma_a.id ], publico_alvo: :docentes)

      expect do
        described_class.call(
          template_id: outro_template.id,
          turma_ids: [ turma_a.id ],
          publico_alvo: :docentes,
          perfil_adm: perfil_adm
        )
      end.not_to raise_error

      expect(turma_a.reload.formularios.count).to eq(2)
      expect(turma_a.formularios.pluck(:template_id)).to contain_exactly(template.id, outro_template.id)
    end

    it "persiste o público-alvo informado" do
      formularios = call_service(turma_ids: [ turma_a.id ], publico_alvo: :discentes)

      expect(formularios.first.publico_alvo).to eq("discentes")
    end

    it "cria avaliações pendentes para o público-alvo da turma" do
      docente = create_usuario(nome: "Docente")
      PerfilDocente.create!(usuario: docente, departamento: departamento)
      ParticipacaoTurma.create!(usuario: docente, turma: turma_a, tipo_participacao: :docente)

      discente = create_usuario(nome: "Discente")
      discente.update!(matricula: "20260001")
      PerfilDiscente.create!(usuario: discente)
      ParticipacaoTurma.create!(usuario: discente, turma: turma_a, tipo_participacao: :discente)

      formularios = call_service(turma_ids: [ turma_a.id ], publico_alvo: :docentes)

      expect(Avaliacao.count).to eq(1)
      expect(formularios.first.avaliacoes.sole.participacao_turma).to eq(docente.participacoes_turma.sole)
      expect(formularios.first.avaliacoes.sole).to be_pendente
    end

    it "levanta erro quando público-alvo não é informado" do
      expect do
        call_service(turma_ids: [ turma_a.id ], publico_alvo: nil)
      end.to raise_error(Formularios::Error, "Por favor, selecione o público-alvo do formulário")

      expect(Formulario.count).to eq(0)
    end

    it "levanta erro quando público-alvo é inválido" do
      expect do
        call_service(turma_ids: [ turma_a.id ], publico_alvo: "invalido")
      end.to raise_error(Formularios::Error, "Por favor, selecione o público-alvo do formulário")

      expect(Formulario.count).to eq(0)
    end
  end

  describe ".validate_preparacao!" do
    def validate_preparacao(**overrides)
      described_class.validate_preparacao!(
        template_id: template.id,
        turma_ids: [ turma_a.id ],
        perfil_adm: perfil_adm,
        **overrides
      )
    end

    it "retorna nil quando dados são válidos" do
      expect(validate_preparacao).to be_nil
    end

    it "levanta erro quando template não possui questões" do
      template_vazio = create_template_with_questoes(titulo: "Vazio", adm: perfil_adm)
      template_vazio.utilizacoes_questoes.destroy_all

      expect do
        validate_preparacao(template_id: template_vazio.id)
      end.to raise_error(Formularios::Error, described_class::SEM_QUESTOES)
    end

    it "levanta erro quando turma não existe" do
      expect do
        validate_preparacao(turma_ids: [ 999_999 ])
      end.to raise_error(Formularios::Error, described_class::TURMAS_INVALIDAS)
    end

    it "levanta erro quando turma pertence a outro departamento" do
      outro_departamento = Departamento.create!(nome: "IC #{SecureRandom.hex(2)}")
      turma_externa = create_turma(nome_materia: "ES", numero: 99, departamento: outro_departamento)

      expect do
        validate_preparacao(turma_ids: [ turma_externa.id ])
      end.to raise_error(Formularios::Error, described_class::TURMAS_INVALIDAS)
    end
  end
end
