require 'rails_helper'

RSpec.describe PasswordResetUsage, type: :model do
  it "é válido com um token presente e único (Happy Path)" do
    expect(PasswordResetUsage.new(token: "abc123")).to be_valid
  end

  it "é inválido sem token (Sad Path)" do
    uso = PasswordResetUsage.new(token: nil)
    expect(uso).not_to be_valid
    expect(uso.errors[:token]).to be_present
  end

  it "é inválido com token duplicado (Sad Path)" do
    PasswordResetUsage.create!(token: "repetido")
    expect(PasswordResetUsage.new(token: "repetido")).not_to be_valid
  end
end
