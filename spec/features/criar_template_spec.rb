require 'rails_helper'

RSpec.describe "Admin creates form templates", type: :feature do
  before do
    User.destroy_all
    admin = User.create!(
      nome: "Admin Teste",
      email: "admin@teste.com",
      password: "123456",
      password_confirmation: "123456",
      ocupacao: "admin"
    )

    visit login_path
    fill_in "Email", with: "admin@teste.com"
    fill_in "Senha", with: "123456"
    click_button "Entrar"
  end

  scenario "Create a form template with valid text question" do
    visit new_admin_template_path

    expect(page).to have_content("Criar Novo Template")

    fill_in "Nome do Template", with: "Avaliação de Ruby"
    fill_in "Descrição", with: "Formulário de teste com pergunta de texto"

    # Encontra o primeiro bloco de pergunta
    within first(".question-item") do
      fill_in "Pergunta", with: "O que você achou da matéria?"
      select "Texto", from: "Tipo"
      check "Pergunta obrigatória"
    end

    click_button "Criar Template"

    
    expect(page).to have_content("Avaliação de Ruby")
  end

  scenario "Create a form template with valid radio question" do
    visit new_admin_template_path

    fill_in "Nome do Template", with: "Avaliação Radio"
    select "Múltipla Escolha", from: "Tipo"
    fill_in "Pergunta", with: "A aula foi clara?"
    #fill_in "Opções", with: "Sim;Não;Mais ou menos"
    click_button "Criar"

    ##expect(page).to have_content("Template criado com sucesso")
    expect(page).to have_content("Avaliação Radio")
  end

  scenario "Create a form template with valid escala question" do
    visit new_admin_template_path

    fill_in "Nome do Template", with: "Avaliação Escala"
    select "Escala", from: "Tipo"
    fill_in "Pergunta", with: "Avalie de 1 a 5 a metodologia do professor"
    click_button "Criar"

    #expect(page).to have_content("Template criado com sucesso")
    expect(page).to have_content("Avaliação Escala")
  end

  scenario "Try to create a template without questions" do
    visit new_admin_template_path

    fill_in "Nome do Template", with: "Sem Perguntas"
    all("input[name*='[text]']").each { |field| field.set("") }

    click_button "Criar"

    #expect(page).to have_content("Template vazio")
  end

  scenario "Try to create a template without a name" do
    visit new_admin_template_path

    fill_in "Pergunta", with: "Qual sua opinião?"
    click_button "Criar"

    #expect(page).to have_content("Template não nomeado")
  end
end
