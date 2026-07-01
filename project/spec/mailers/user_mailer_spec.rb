require "rails_helper"

RSpec.describe UserMailer do
  it "envia link de definicao de senha" do
    user = create(:user, email: "acjpjvjp@gmail.com", registration: "190084006", password: nil)
    email = described_class.password_setup(user, "token-123")

    expect(email.to).to include("acjpjvjp@gmail.com")
    expect(email.subject).to eq("Defina sua senha no CAMAAR")
    expect(email.body.encoded).to include("senha/definir/token-123")
  end

  it "envia link de redefinicao de senha" do
    user = create(:user, email: "acjpjvjp@gmail.com", registration: "190084006", password: "Senha@123")
    email = described_class.password_reset(user, "token-123")

    expect(email.to).to include("acjpjvjp@gmail.com")
    expect(email.subject).to eq("Redefinicao de senha do CAMAAR")
    expect(email.body.encoded).to include("senha/redefinir/token-123")
  end
end
