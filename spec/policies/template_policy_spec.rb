# frozen_string_literal: true

require "rails_helper"

RSpec.describe TemplatePolicy do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:outro_admin) { create_admin_usuario(departamento: departamento) }
  let(:usuario) { create_usuario }
  let(:template) { create_template_with_questoes(titulo: "Avaliação", adm: admin.perfil_adm) }

  describe ".scope" do
    it "retorna todos os templates para administrador" do
      template

      expect(described_class.scope(admin, Template)).to include(template)
    end

    it "retorna escopo vazio para usuário sem perfil administrativo" do
      template

      expect(described_class.scope(usuario, Template)).to be_empty
    end
  end

  describe "ações de leitura e criação" do
    it "permite administrador" do
      policy = described_class.new(admin, Template)

      expect(policy.index?).to be(true)
      expect(policy.show?).to be(true)
      expect(policy.new?).to be(true)
      expect(policy.create?).to be(true)
      expect(policy.use?).to be(true)
    end

    it "nega usuário sem perfil administrativo" do
      policy = described_class.new(usuario, Template)

      expect(policy.index?).to be(false)
      expect(policy.show?).to be(false)
      expect(policy.new?).to be(false)
      expect(policy.create?).to be(false)
      expect(policy.use?).to be(false)
    end
  end

  describe "ações de alteração" do
    it "permite o administrador dono do template" do
      policy = described_class.new(admin, template)

      expect(policy.edit?).to be(true)
      expect(policy.update?).to be(true)
      expect(policy.destroy?).to be(true)
    end

    it "nega outro administrador" do
      policy = described_class.new(outro_admin, template)

      expect(policy.edit?).to be(false)
      expect(policy.update?).to be(false)
      expect(policy.destroy?).to be(false)
    end
  end
end
