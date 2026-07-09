require "rails_helper"

RSpec.describe User, type: :model do
  let(:valid_attrs) do
    { nome: "Teste", email: "teste@camaar.com", matricula: "202400001", perfil: "Discente" }
  end

  describe "importação sem senha" do
    it "salva sem password_digest e com primeiro_acesso true por padrão" do
      user = User.create!(valid_attrs)
      expect(user.password_digest).to be_nil
      expect(user.primeiro_acesso).to be(true)
    end

    it "password_set? retorna false sem senha" do
      user = User.create!(valid_attrs)
      expect(user.password_set?).to be(false)
    end
  end

  describe "definição de senha válida" do
    it "salva com senha, password_set? true, primeiro_acesso false" do
      user = User.create!(valid_attrs.merge(
        password: "senha123",
        password_confirmation: "senha123",
        primeiro_acesso: false
      ))
      expect(user.password_set?).to be(true)
      expect(user.primeiro_acesso).to be(false)
      expect(user.authenticate("senha123")).to eq(user)
    end
  end

  describe "validações de senha" do
    it "é inválido quando senhas não correspondem" do
      user = User.new(valid_attrs.merge(password: "senhaA", password_confirmation: "senhaB"))
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to be_present
    end

    it "é inválido quando senha é muito curta" do
      user = User.new(valid_attrs.merge(password: "abc", password_confirmation: "abc"))
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it "é válido sem senha (importação)" do
      user = User.new(valid_attrs)
      expect(user).to be_valid
    end
  end

  describe "validações de campos obrigatórios" do
    it "exige nome" do
      user = User.new(valid_attrs.except(:nome))
      expect(user).not_to be_valid
    end

    it "exige email único" do
      User.create!(valid_attrs)
      user2 = User.new(valid_attrs.merge(matricula: "999999"))
      expect(user2).not_to be_valid
    end

    it "exige matricula única" do
      User.create!(valid_attrs)
      user2 = User.new(valid_attrs.merge(email: "outro@camaar.com"))
      expect(user2).not_to be_valid
    end
  end
end
