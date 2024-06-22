require 'rails_helper'

RSpec.describe User, type: :model do
  it "é válido com atributos válidos" do
    user = build(:user,:user1)
    expect(user).to be_valid
  end

  it "é inválido com email inválido" do
    user = build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it "é inválido com senha inválida" do
    user = build(:user, password: nil)
    expect(user).to_not be_valid
  end

  it "não pode haver usuarios com o mesmo email" do
    user1 = create(:user,:user1)
    user2 = build(:user, email: user1.email)
    expect(user2).to_not be_valid
  end

  it "os atributos podem se assimilar, mas o email é único" do
    user1 = create(:user,:user1)
    user2 = build(:user, email: "unique@example.com")
    expect(user2).to be_valid
  end
end
