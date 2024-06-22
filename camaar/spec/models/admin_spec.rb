require 'rails_helper'

RSpec.describe Admin, type: :model do
  it 'é válido com atributos válidos' do
    admin = build(:admin, :admin1)
    admin2 = build(:admin, :admin2)
    expect(admin).to be_valid
    expect(admin2).to be_valid
  end

  it 'é inválido com email inválido' do
    admin = build(:admin, email: nil)
    expect(admin).to_not be_valid
  end

  it 'é inválido com senha inválida' do
    admin = build(:admin, password: nil)
    expect(admin).to_not be_valid
  end

  it 'não pode haver usuarios com o mesmo email' do
    admin1 = create(:admin, :admin1)
    admin2 = build(:admin, email: admin1.email)
    expect(admin2).to_not be_valid
  end

  it 'os atributos podem se assimilar, mas o email é único' do
    admin1 = create(:admin, :admin1)
    admin2 = build(:admin, email: 'unique@example.com')
    expect(admin2).to be_valid
  end
end
