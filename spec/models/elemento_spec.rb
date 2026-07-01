require 'rails_helper'

RSpec.describe Elemento, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:admin) do
    Administrador.find_or_create_by!(email: "admin_elem@unb.br") do |a|
      a.nome = "Admin Elem"
      a.matricula = "adm_elem"
      a.senha = "Senha123"
      a.departamento = departamento
    end
  end
  let(:template) do
    t = Template.new(nome: "Template Teste", administrador: admin)
    t.save(validate: false)
    t
  end

  context "validações e associações" do
    it "é válido quando associado a um template" do
      elemento = Elemento.new(enunciado: "Questão 1", ordem: 1, template: template)
      expect(elemento).to be_valid
    end

    it "não é válido sem template" do
      elemento = Elemento.new(enunciado: "Questão 1", ordem: 1)
      expect(elemento).not_to be_valid
    end

    it "possui associação com campos" do
      expect(Elemento.new).to respond_to(:campos)
    end

    it "possui associação com template" do
      expect(Elemento.new).to respond_to(:template)
    end
  end
end
