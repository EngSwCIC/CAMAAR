# spec/models/envio_formulario_spec.rb
require "rails_helper"

RSpec.describe EnvioFormulario, type: :model do
  let(:depto)      { create(:departamento) }
  let(:usr_doc)    { create(:usuario, perfil: :docente) }
  let(:docente)    { create(:docente, usuario: usr_doc, departamento: depto) }
  let(:disciplina) { create(:disciplina) }
  let(:turma)      { create(:turma, disciplina: disciplina, docente: docente) }
  let(:template)   { create(:template, docente: docente) }
  let(:formulario) { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }
  let(:usr_disc)   { create(:usuario, perfil: :discente) }
  let(:discente)   { create(:discente, usuario: usr_disc) }

  describe "associações" do
    it { is_expected.to belong_to(:formulario) }
    it { is_expected.to belong_to(:discente) }
    it { is_expected.to have_many(:respostas).dependent(:destroy) }
  end

  describe "validações" do
    it "é inválido com par formulario+discente duplicado" do
      create(:envio_formulario, formulario: formulario, discente: discente)
      duplicado = build(:envio_formulario, formulario: formulario, discente: discente)
      expect(duplicado).not_to be_valid
      expect(duplicado.errors[:formulario_id]).to be_present
    end

    it "é válido com par formulario+discente único" do
      envio = build(:envio_formulario, formulario: formulario, discente: discente)
      expect(envio).to be_valid
    end

    it "é inválido quando formulário está encerrado" do
      formulario.update!(prazo: 1.day.ago)
      envio = build(:envio_formulario, formulario: formulario, discente: discente)
      expect(envio).not_to be_valid
      expect(envio.errors[:base]).to include(match(/prazo/i))
    end
  end

  describe "callbacks" do
    it "registra enviado_em automaticamente no create" do
      envio = create(:envio_formulario, formulario: formulario, discente: discente, enviado_em: nil)
      expect(envio.reload.enviado_em).not_to be_nil
    end
  end
end

# spec/models/resposta_spec.rb
RSpec.describe Resposta, type: :model do
  describe "associações" do
    it { is_expected.to belong_to(:envio_formulario) }
    it { is_expected.to belong_to(:questao) }
  end

  describe "validações" do
    it { is_expected.to validate_presence_of(:conteudo) }
  end
end
