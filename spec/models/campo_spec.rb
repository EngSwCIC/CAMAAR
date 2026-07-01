require 'rails_helper'

RSpec.describe Campo, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:admin) do
    Administrador.find_or_create_by!(email: "admin_campo@unb.br") do |a|
      a.nome = "Admin Campo"
      a.matricula = "adm_campo"
      a.senha = "Senha123"
      a.departamento = departamento
    end
  end
  let(:template) do
    t = Template.new(nome: "Template", administrador: admin)
    t.save(validate: false)
    t
  end
  let(:elemento) { Elemento.create!(enunciado: "Questão 1", ordem: 1, template: template) }

  context "validações" do
    it "é válido com todos os atributos obrigatórios" do
      campo = Campo.new(ordem: 1, tipo_elemento: "Multipla Escolha", elemento: elemento)
      expect(campo).to be_valid
    end

    it "não é válido sem ordem" do
      campo = Campo.new(tipo_elemento: "Multipla Escolha", elemento: elemento)
      expect(campo).not_to be_valid
      expect(campo.errors[:ordem]).to be_present
    end

    it "não é válido sem tipo_elemento" do
      campo = Campo.new(ordem: 1, elemento: elemento)
      expect(campo).not_to be_valid
      expect(campo.errors[:tipo_elemento]).to be_present
    end

    it "não é válido sem elemento" do
      campo = Campo.new(ordem: 1, tipo_elemento: "Multipla Escolha")
      expect(campo).not_to be_valid
    end

    it "não é válido com ordem duplicada no mesmo elemento" do
      Campo.create!(ordem: 1, tipo_elemento: "Texto", elemento: elemento)
      outro = Campo.new(ordem: 1, tipo_elemento: "Multipla Escolha", elemento: elemento)
      expect(outro).not_to be_valid
      expect(outro.errors[:ordem]).to be_present
    end

    it "é válido com ordens distintas no mesmo elemento" do
      Campo.create!(ordem: 1, tipo_elemento: "Texto", elemento: elemento)
      outro = Campo.new(ordem: 2, tipo_elemento: "Multipla Escolha", elemento: elemento)
      expect(outro).to be_valid
    end
  end

  context "associações" do
    it "possui associação com elemento" do
      expect(Campo.new).to respond_to(:elemento)
    end
  end
end
