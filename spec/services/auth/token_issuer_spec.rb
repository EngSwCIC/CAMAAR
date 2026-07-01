# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auth::TokenIssuer do
  it "gera o valor do token e persiste o registro associado ao usuário" do
    usuario = create_usuario

    expect do
      @token_value = described_class.call(usuario: usuario, tipo: "cadastro")
    end.to change(Token, :count).by(1)

    token = usuario.tokens.sole
    expect(token.value).to eq(@token_value)
    expect(token.tipo).to eq("cadastro")
    expect(token.expires_at).to be_within(1.second).of(10.minutes.from_now)
  end
end
