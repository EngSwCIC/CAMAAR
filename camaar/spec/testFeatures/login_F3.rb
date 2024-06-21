# spec/system/login_spec.rb
require 'rails_helper'

RSpec.describe 'Sistema de login', type: :system do
  # Configuração para usar Selenium em modo headless
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'Login bem-sucedido via teste_create' do
    # Simula uma requisição POST para a rota nomeada teste_create_path
    post teste_create_path, params: { username: 'test_user', password: 'testepassword' }

    # Verifica se a resposta redireciona para a página correta e exibe a mensagem de sucesso
    expect(response).to redirect_to(login_path)
    follow_redirect!

    expect(response.body).to include('Login realizado com sucesso!')
  end

  it 'Falha no login com credenciais inválidas via teste_create' do
    # Simula uma requisição POST para a rota nomeada teste_create_path
    post teste_create_path, params: { username: 'wrong@aluno.unb.br', password: 'wrongpassword' }

    # Verifica se a resposta redireciona para a página de login e exibe a mensagem de erro
    expect(response).to redirect_to(login_path)
    follow_redirect!

    expect(response.body).to include('Invalid username or password')
  end
end
