require 'rails_helper'

RSpec.describe User, type: :model do

  before(:context) do
    User.delete_all
    @user = User.new(
      nome: "Fulano", 
      email: "teste@email.com", 
      curso: "CIÊNCIA DA COMPUTAÇÃO/CIC", 
      matricula: "123456789", 
      usuario: "123456789", 
      formacao: "graduando", 
      ocupacao: "discente", 
      password: "password", 
      password_confirmation: "password"
    )
    @user.skip_confirmation_notification!
    expect(@user.save).to be true
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