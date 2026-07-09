# spec/models/formulario_spec.rb
require "rails_helper"   # ← CORREÇÃO: arquivo estava ausente

RSpec.describe Formulario, type: :model do
  let(:depto)      { create(:departamento) }
  let(:usr_doc)    { create(:usuario, perfil: :docente) }
  let(:docente)    { create(:docente, usuario: usr_doc, departamento: depto) }
  let(:disciplina) { create(:disciplina) }
  let(:turma)      { create(:turma, disciplina: disciplina, docente: docente) }
  let(:template)   { create(:template, docente: docente) }

  describe "associações" do
    it { is_expected.to belong_to(:turma) }
    it { is_expected.to belong_to(:template) }
    it { is_expected.to have_many(:questoes).dependent(:destroy) }
    it { is_expected.to have_many(:envio_formularios).dependent(:destroy) }
  end

  describe "validações" do
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe "scopes" do
    let!(:aberto)     { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }
    let!(:fechado)    { create(:formulario, turma: turma, template: template, prazo: 1.day.ago) }
    let!(:sem_prazo)  { create(:formulario, turma: turma, template: template, prazo: nil) }

    it "scope abertos inclui prazo futuro e sem prazo" do
      expect(Formulario.abertos).to include(aberto, sem_prazo)
      expect(Formulario.abertos).not_to include(fechado)
    end

    it "scope fechados inclui apenas prazo passado" do
      expect(Formulario.fechados).to include(fechado)
      expect(Formulario.fechados).not_to include(aberto, sem_prazo)
    end
  end

  describe "#aberto?" do
    it "true quando prazo é futuro"  do
      f = build(:formulario, turma: turma, template: template, prazo: 1.day.from_now)
      expect(f.aberto?).to be true
    end

    it "true quando sem prazo" do
      f = build(:formulario, turma: turma, template: template, prazo: nil)
      expect(f.aberto?).to be true
    end

    it "false quando prazo passou" do
      f = build(:formulario, turma: turma, template: template, prazo: 1.day.ago)
      expect(f.aberto?).to be false
    end
  end

  describe "#respondido_por?" do
    let(:formulario) { create(:formulario, turma: turma, template: template) }
    let(:usr_disc)   { create(:usuario, perfil: :discente) }
    let(:discente)   { create(:discente, usuario: usr_disc) }

    it "false quando não respondeu" do
      expect(formulario.respondido_por?(discente)).to be false
    end

    it "true quando já respondeu" do
      create(:envio_formulario, formulario: formulario, discente: discente)
      expect(formulario.respondido_por?(discente)).to be true
    end
  end
end
