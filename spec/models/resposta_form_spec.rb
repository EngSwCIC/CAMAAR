require 'rails_helper'

RSpec.describe RespostaForm, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
  let(:formulario) { Formulario.create!(turma: turma) }
  let(:docente) do
    Docente.find_or_create_by!(email: "doc_rf@unb.br") do |d|
      d.nome = "Docente RF"
      d.matricula = "doc_rf001"
      d.formacao = "Doutorado"
      d.senha = "Senha123"
    end
  end

  context "validações" do
    it "é válido com todos os atributos obrigatórios" do
      rf = RespostaForm.new(data_submissao: Date.today, formulario: formulario, usuario: docente)
      expect(rf).to be_valid
    end

    it "não é válido sem data_submissao" do
      rf = RespostaForm.new(formulario: formulario, usuario: docente)
      expect(rf).not_to be_valid
      expect(rf.errors[:data_submissao]).to be_present
    end

    it "não é válido sem formulario" do
      rf = RespostaForm.new(data_submissao: Date.today, usuario: docente)
      expect(rf).not_to be_valid
    end

    it "não é válido sem usuario" do
      rf = RespostaForm.new(data_submissao: Date.today, formulario: formulario)
      expect(rf).not_to be_valid
    end

    it "não é válido quando o mesmo usuário responde o mesmo formulário duas vezes" do
      RespostaForm.create!(data_submissao: Date.today, formulario: formulario, usuario: docente)
      duplicado = RespostaForm.new(data_submissao: Date.today, formulario: formulario, usuario: docente)
      expect(duplicado).not_to be_valid
      expect(duplicado.errors[:usuario_id]).to be_present
    end

    it "é válido quando usuários diferentes respondem o mesmo formulário" do
      outro = Docente.find_or_create_by!(email: "doc2_rf@unb.br") do |d|
        d.nome = "Docente 2"
        d.matricula = "doc2_rf"
        d.formacao = "Mestrado"
        d.senha = "Senha123"
      end
      RespostaForm.create!(data_submissao: Date.today, formulario: formulario, usuario: docente)
      segundo = RespostaForm.new(data_submissao: Date.today, formulario: formulario, usuario: outro)
      expect(segundo).to be_valid
    end
  end

  context "associações" do
    it "possui associação com resposta_elems" do
      expect(RespostaForm.new).to respond_to(:resposta_elems)
    end

    it "possui associação com formulario" do
      expect(RespostaForm.new).to respond_to(:formulario)
    end

    it "possui associação com usuario" do
      expect(RespostaForm.new).to respond_to(:usuario)
    end
  end
end
