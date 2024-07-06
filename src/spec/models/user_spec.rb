require 'rails_helper'

RSpec.describe User, type: :model do

  before(:context) do
    cria_usuario
  end

  context "Cria um usuário arbitrário" do

    it " e Deve criar um usuário com sucesso" do
      expect(@user.is_a? User).to be true
    end

    it " e Deve ser achado pelo e-mail com sucesso" do
      expect(User.find_by_email("teste@email.com") == @user).to be true
    end

    it " e Deve ser atualizado" do
      @user.nome = "Beltrano"
      expect(@user.save).to be true
      expect(User.find_by_email("teste@email.com").nome).to eq("Beltrano")
    end

    it " e Deve ser excluído" do
      @user.destroy
      expect(@user.destroyed?). to be true
      expect(User.find_by_email("teste@email.com")).to be nil
    end
  end
end