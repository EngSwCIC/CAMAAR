require 'rails_helper'

RSpec.describe Usuario, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:curso) { Curso.find_or_create_by!(nome: "Engenharia de Software", codigo: "ESW", departamento: departamento) }

  let(:docente_valido) do
    Docente.new(
      nome: "Professor Teste",
      matricula: "doc001",
      email: "prof@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end

  context "validações" do
    it "é válido com todos os atributos obrigatórios" do
      expect(docente_valido).to be_valid
    end

    it "não é válido sem nome" do
      docente_valido.nome = nil
      expect(docente_valido).not_to be_valid
    end

    it "não é válido sem matrícula" do
      docente_valido.matricula = nil
      expect(docente_valido).not_to be_valid
    end

    it "não é válido sem email" do
      docente_valido.email = nil
      expect(docente_valido).not_to be_valid
    end

    it "não é válido com matrícula duplicada" do
      docente_valido.save!
      outro = Docente.new(
        nome: "Outro Prof",
        matricula: "doc001",
        email: "outro@unb.br",
        formacao: "Mestrado",
        senha: "Senha123",
        senha_confirmation: "Senha123"
      )
      expect(outro).not_to be_valid
    end

    it "não é válido com email duplicado" do
      docente_valido.save!
      outro = Docente.new(
        nome: "Outro Prof",
        matricula: "doc002",
        email: "prof@unb.br",
        formacao: "Mestrado",
        senha: "Senha123",
        senha_confirmation: "Senha123"
      )
      expect(outro).not_to be_valid
    end

    it "não é válido com senha menor que 6 caracteres" do
      docente_valido.senha = "abc"
      docente_valido.senha_confirmation = "abc"
      expect(docente_valido).not_to be_valid
    end

    it "não é válido quando confirmação de senha não confere" do
      docente_valido.senha_confirmation = "outra_senha"
      expect(docente_valido).not_to be_valid
    end
  end

  context "#senha_definida?" do
    it "retorna false quando senha_hash está em branco" do
      usuario = Docente.new(nome: "X", matricula: "x1", email: "x@x.com", formacao: "Grad")
      expect(usuario.senha_definida?).to be false
    end

    it "retorna true após definir e salvar uma senha" do
      docente_valido.save!
      expect(docente_valido.senha_definida?).to be true
    end
  end

  context "#autenticar_senha" do
    before { docente_valido.save! }

    it "retorna true com a senha correta" do
      expect(docente_valido.autenticar_senha("Senha123")).to be true
    end

    it "retorna false com a senha incorreta" do
      expect(docente_valido.autenticar_senha("errada")).to be false
    end

    it "retorna false quando senha_hash está em branco" do
      usuario = Docente.new(nome: "Y", matricula: "y1", email: "y@y.com", formacao: "Grad")
      expect(usuario.autenticar_senha("qualquer")).to be false
    end
  end

  context "#gerar_definicao_senha_token!" do
    before { docente_valido.save! }

    it "preenche definicao_senha_token" do
      docente_valido.gerar_definicao_senha_token!
      expect(docente_valido.definicao_senha_token).to be_present
    end

    it "preenche definicao_senha_sent_at" do
      docente_valido.gerar_definicao_senha_token!
      expect(docente_valido.definicao_senha_sent_at).to be_present
    end
  end

  context "#limpar_definicao_senha_token!" do
    before do
      docente_valido.save!
      docente_valido.gerar_definicao_senha_token!
    end

    it "apaga definicao_senha_token" do
      docente_valido.limpar_definicao_senha_token!
      expect(docente_valido.definicao_senha_token).to be_nil
    end

    it "apaga definicao_senha_sent_at" do
      docente_valido.limpar_definicao_senha_token!
      expect(docente_valido.definicao_senha_sent_at).to be_nil
    end
  end

  context "#gerar_redefinicao_senha_token!" do
    before { docente_valido.save! }

    it "preenche redefinicao_senha_token" do
      docente_valido.gerar_redefinicao_senha_token!
      expect(docente_valido.redefinicao_senha_token).to be_present
    end

    it "preenche redefinicao_senha_sent_at" do
      docente_valido.gerar_redefinicao_senha_token!
      expect(docente_valido.redefinicao_senha_sent_at).to be_present
    end
  end

  context "#limpar_redefinicao_senha_token!" do
    before do
      docente_valido.save!
      docente_valido.gerar_redefinicao_senha_token!
    end

    it "apaga redefinicao_senha_token" do
      docente_valido.limpar_redefinicao_senha_token!
      expect(docente_valido.redefinicao_senha_token).to be_nil
    end

    it "apaga redefinicao_senha_sent_at" do
      docente_valido.limpar_redefinicao_senha_token!
      expect(docente_valido.redefinicao_senha_sent_at).to be_nil
    end
  end
end
