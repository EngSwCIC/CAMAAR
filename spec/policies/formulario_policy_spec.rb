# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormularioPolicy do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:outro_departamento) { Departamento.create!(nome: "IC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:usuario) { create_usuario }
  let(:turma) { create_turma(nome_materia: "MDS", numero: 1, departamento: departamento) }
  let(:turma_outro_depto) { create_turma(nome_materia: "IHC", numero: 1, departamento: outro_departamento) }
  let(:template) { create_template_with_questoes(titulo: "Avaliação", adm: admin.perfil_adm) }
  let(:formulario) { Formulario.new(adm: admin.perfil_adm) }
  let!(:formulario_do_depto) { create_formulario(turma: turma, adm: admin.perfil_adm, template: template) }
  let!(:formulario_outro_depto) do
    outro_admin = create_admin_usuario(departamento: outro_departamento)
    outro_template = create_template_with_questoes(titulo: "Outro", adm: outro_admin.perfil_adm)
    create_formulario(turma: turma_outro_depto, adm: outro_admin.perfil_adm, template: outro_template)
  end

  describe "#index?" do
    it "permite administrador" do
      expect(described_class.new(admin, Formulario).index?).to be(true)
    end

    it "nega usuário sem perfil de administrador" do
      expect(described_class.new(usuario, Formulario).index?).to be(false)
    end
  end

  describe "#show?" do
    it "permite administrador para formulário do mesmo departamento" do
      expect(described_class.new(admin, formulario_do_depto).show?).to be(true)
    end

    it "nega administrador para formulário de outro departamento" do
      expect(described_class.new(admin, formulario_outro_depto).show?).to be(false)
    end

    it "nega usuário sem perfil de administrador" do
      expect(described_class.new(usuario, formulario_do_depto).show?).to be(false)
    end

    it "permite administrador quando record é a classe Formulario" do
      expect(described_class.new(admin, Formulario).show?).to be(true)
    end
  end

  describe "#exportar_csv?" do
    it "permite administrador para formulário do mesmo departamento" do
      expect(described_class.new(admin, formulario_do_depto).exportar_csv?).to be(true)
    end

    it "nega administrador para formulário de outro departamento" do
      expect(described_class.new(admin, formulario_outro_depto).exportar_csv?).to be(false)
    end

    it "nega usuário sem perfil de administrador" do
      expect(described_class.new(usuario, formulario_do_depto).exportar_csv?).to be(false)
    end
  end

  describe "#create?" do
    it "permite administrador" do
      expect(described_class.new(admin, formulario).create?).to be(true)
    end

    it "nega usuário sem perfil de administrador" do
      expect(described_class.new(usuario, formulario).create?).to be(false)
    end

    it "nega visitante não autenticado" do
      expect(described_class.new(nil, formulario).create?).to be_falsy
    end
  end

  describe "#new?" do
    it "delega para create?" do
      policy = described_class.new(admin, formulario)
      expect(policy.new?).to eq(policy.create?)
    end
  end
end
