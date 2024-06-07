require 'rails_helper'

RSpec.describe Admin, type: :model do
  it "é válido com atributos válidos" do
    admin = FactoryBot.build(:admin)
    expect(admin).to be_valid
  end

  it "é inválido com email inválido" do
    admin = FactoryBot.build(:admin, email: nil)
    expect(admin).to_not be_valid
  end

  it "é inválido com senha inválida" do
    admin = FactoryBot.build(:admin, password: nil)
    expect(admin).to_not be_valid
  end

  it "não pode haver usuarios com o mesmo email" do
    admin1 = FactoryBot.create(:admin)
    admin2 = FactoryBot.build(:admin, email: admin1.email)
    expect(admin2).to_not be_valid
  end

  it "os atributos podem se assimilar, mas o email é único" do
    admin1 = FactoryBot.create(:admin)
    admin2 = FactoryBot.build(:admin, email: "unique@example.com")
    expect(admin2).to be_valid
  end
end
