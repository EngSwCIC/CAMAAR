# spec/models/discente_spec.rb
require "rails_helper"   # ← CORREÇÃO: era ausente / não executável

RSpec.describe Discente, type: :model do
  let(:depto)      { create(:departamento) }
  let(:usr_doc)    { create(:usuario, perfil: :docente) }
  let(:docente)    { create(:docente, usuario: usr_doc, departamento: depto) }
  let(:disciplina) { create(:disciplina) }
  let(:turma_a)    { create(:turma, disciplina: disciplina, docente: docente) }
  let(:turma_b)    { create(:turma, disciplina: disciplina, docente: docente) }
  let(:usr_disc)   { create(:usuario, perfil: :discente) }
  let(:discente)   { create(:discente, usuario: usr_disc) }

  before { create(:matricula, discente: discente, turma: turma_a) }

  # ── Associações ──────────────────────────────────────────────────────
  describe "associações" do
    it { is_expected.to belong_to(:usuario) }
    it { is_expected.to have_many(:matriculas).dependent(:destroy) }
    it { is_expected.to have_many(:turmas).through(:matriculas) }
    it { is_expected.to have_many(:envio_formularios).dependent(:destroy) }
  end

  # ── Validações ───────────────────────────────────────────────────────
  describe "validações" do
    it { is_expected.to validate_presence_of(:curso) }
    it { is_expected.to validate_presence_of(:matricula) }
    it { is_expected.to validate_uniqueness_of(:matricula) }
  end

  # ── #formularios_disponiveis ─────────────────────────────────────────
  describe "#formularios_disponiveis" do
    let(:template)   { create(:template, docente: docente) }

    context "formulário na turma em que está matriculado" do
      let!(:formulario) { create(:formulario, turma: turma_a, template: template) }

      it "inclui o formulário" do
        expect(discente.formularios_disponiveis).to include(formulario)
      end

      context "quando já respondeu" do
        before { create(:envio_formulario, discente: discente, formulario: formulario) }

        it "não inclui o formulário respondido" do
          expect(discente.formularios_disponiveis).not_to include(formulario)
        end
      end
    end

    context "formulário em turma que NÃO está matriculado" do
      let!(:formulario) { create(:formulario, turma: turma_b, template: template) }

      it "não inclui o formulário" do
        expect(discente.formularios_disponiveis).not_to include(formulario)
      end
    end
  end

  # ── #ja_respondeu? ───────────────────────────────────────────────────
  describe "#ja_respondeu?" do
    let(:template)   { create(:template, docente: docente) }
    let(:formulario) { create(:formulario, turma: turma_a, template: template) }

    it "retorna false antes de responder" do
      expect(discente.ja_respondeu?(formulario)).to be false
    end

    it "retorna true após responder" do
      create(:envio_formulario, discente: discente, formulario: formulario)
      expect(discente.ja_respondeu?(formulario)).to be true
    end
  end
end
