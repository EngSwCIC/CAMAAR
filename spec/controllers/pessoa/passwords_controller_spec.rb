require 'rails_helper'

RSpec.feature "Definição de senha via e-mail (mockada)", type: :feature do
  include ActionMailer::TestHelper

  let!(:pessoa) do
    Pessoa.create!(
      email: "nova@exemplo.com",
      nome: "Usuária Teste",
      matricula: "2023123456",
      password: nil,
      password_confirmation: nil
    )
  end

  before do
    Devise.mappings[:pessoa] ||= Devise::Mapping.new(:pessoa, {})
    ActionMailer::Base.deliveries.clear
  end

  scenario "Usuária define nova senha com token válido" do
    # Gera o token e associa ao usuário
    raw_token, enc_token = Devise.token_generator.generate(Pessoa, :reset_password_token)
    pessoa.update!(
      reset_password_token: enc_token,
      reset_password_sent_at: Time.current
    )

    # Envia o e-mail manualmente (simulado)
    Devise::Mailer.reset_password_instructions(pessoa, raw_token).deliver_now
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include("nova@exemplo.com")

    # Extrai o token do link no e-mail
    link = mail.body.encoded.match(/href="(?<url>.+?)"/)[:url]
    token = CGI.parse(URI.parse(link).query)["reset_password_token"].first

    # Acessa a página de definição de senha com o token
    visit edit_pessoa_password_path(reset_password_token: token)

    fill_in "Nova Senha", with: "senhanova123"
    fill_in "Confirme a Senha", with: "senhanova123"
    click_button "Definir Senha"

    expect(page).to have_content("Login efetuado com sucesso")

    pessoa.reload
    expect(pessoa.valid_password?("senhanova123")).to be true
  end

  scenario "Usuária tenta redefinir senha com token inválido" do
    visit edit_pessoa_password_path(reset_password_token: "token_invalido")

    fill_in "Nova Senha", with: "senhanova123"
    fill_in "Confirme a Senha", with: "senhanova123"
    click_button "Definir Senha"

    expect(page).to have_content("Token de redefinição de senha é inválido")
  end
end
