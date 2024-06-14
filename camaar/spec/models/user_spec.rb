require 'rails_helper'

RSpec.describe User, type: :model do
  describe "para que seja válida" do
    it "deve ser válida :)" do
      user = create(:user)
      expect(user).to be_valid
    end

    it "deve possuir um email" do
      user = build(:user, email:nil)
      expect(user).to_not  be_valid
    end
    it "o email deve ser válido" do
      user = create(:user)
      expect(user.email).to match(/\A[\w+]+@[a-z]+\.[a-z]+\z/i)
    end

    it "deve possuir uma matrícula" do
      user = build(:user, matricula:nil)
      expect(user).to_not  be_valid
    end
    it "a matrícula deve ser válida" do
      user = create(:user)
      expect(user.matricula).to match(/\A[0-9]{9}\z/)
    end

    it "deve fazer parte de um curso" do
      user = build(:user, curso:nil)
      expect(user).to_not  be_valid
    end

    it "deve possuir um nome" do
      user = build(:user, nome:nil)
      expect(user).to_not  be_valid
    end

    it "deve fazer parte de uma formação" do
      user = build(:user, formacao:nil)
      expect(user).to_not  be_valid
    end

    it "deve possuir uma ocupação" do
      user = build(:user, ocupacao:nil)
      expect(user).to_not  be_valid
    end
    it "deve possuir uma password" do
      user = build(:user, password:nil)
      expect(user).to_not  be_valid
    end
    it "deve possuir uma password_confirmation" do
      user = build(:user, password_confirmation:nil)
      expect(user).to_not  be_valid
    end
    it "deve possuir uma token de resetar a senha nula" do
      user = build(:user, reset_password_token:nil)
      expect(user).to  be_valid
    end
    it "deve possuir uma token de resetar nula" do
      user = build(:user, reset_password_sent_at:nil)
      expect(user).to  be_valid
    end
    it "não deve lembrar da senha" do
      user = build(:user, remember_created_at:nil)
      expect(user).to  be_valid
    end
  end

  describe "para ter relações válidas" do
    it "pode ter várias matrículas" do
      user = User.reflect_on_association(:matriculas)
      expect(user.macro).to eq(:has_many)
    end

    it "pode ter várias turmas" do
      user = User.reflect_on_association(:turmas)
      expect(user.macro).to eq(:has_many)
    end
  end
end
