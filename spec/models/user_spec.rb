require "rails_helper"

RSpec.describe Usuario, type: :model do
  describe "validations" do
    it "requires nome" do
      usuario = build(:usuario, nome: nil)
      expect(usuario).not_to be_valid
      expect(usuario.errors[:nome]).to be_present
    end

    it "requires email" do
      usuario = build(:usuario, email: nil)
      expect(usuario).not_to be_valid
      expect(usuario.errors[:email]).to be_present
    end
  end

  describe "email uniqueness" do
    it "rejects duplicate emails" do
      create(:usuario, email: "test@example.com")
      duplicate = build(:usuario, email: "test@example.com")
      expect(duplicate).not_to be_valid
    end
  end

  describe "roles" do
    it "can be estudante" do
      usuario = build(:usuario, role: :estudante)
      expect(usuario.estudante?).to be true
    end

    it "can be admin" do
      usuario = build(:usuario, :admin)
      expect(usuario.admin?).to be true
    end

    it "can be professor" do
      usuario = build(:usuario, :professor)
      expect(usuario.professor?).to be true
    end
  end

  describe "authentication" do
    it "authenticates with correct password" do
      usuario = create(:usuario, password: "Senha123", password_confirmation: "Senha123")
      expect(usuario.authenticate("Senha123")).to eq(usuario)
    end

    it "rejects wrong password" do
      usuario = create(:usuario, password: "Senha123", password_confirmation: "Senha123")
      expect(usuario.authenticate("wrong")).to be false
    end
  end
end
