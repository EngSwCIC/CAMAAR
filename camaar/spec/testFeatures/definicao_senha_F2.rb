# spec/system/login_spec.rb
require 'rails_helper'

RSpec.describe 'Sistema de definição de senha', type: :system do
  # Configuração para usar Selenium em modo headless
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'Definir senha com sucesso' do
    # Simula uma requisição POST para a rota nomeada teste_create_path
    post teste_definir_senha_path, params: { username: 'test_user',
                                             new_password: 'testpassword',
                                             new_password_confirmation: 'testpassword'}

    # Verifica se a resposta redireciona para a página correta e exibe a mensagem de sucesso
    expect(response).to redirect_to(login_path)
    follow_redirect!

    expect(response.body).to include('Definir senha com sucesso')
  end

  it 'Senha e confirmação de senha não coincidem' do
    post teste_definir_senha_path, params: { username: 'test_user',
                                             new_password: 'testpassword',
                                             new_password_confirmation: 'testpassworderrada'}

    # Verifica se a resposta redireciona para a página correta e exibe a mensagem de sucesso
    expect(response).to redirect_to(recuperar_senha_path)
    follow_redirect!

    expect(response.body).to include('Senha e confirmação de senha não coincidem')
  end

  it 'Senha não atende aos critérios de segurança' do
    post teste_definir_senha_path, params: { username: 'test_user',
                                             new_password: '',
                                             new_password_confirmation: ''}

    # Verifica se a resposta redireciona para a página correta e exibe a mensagem de sucesso
    expect(response).to redirect_to(recuperar_senha_path)
    follow_redirect!

    expect(response.body).to include('Senha não atende aos critérios de segurança')
  end
end
