require 'rails_helper'

RSpec.feature "Template Creation", type: :feature do
  scenario "Professor acessa a página de criação de template" do
    visit new_formulario_template_path
    expect(page).to have_content("Novo Template")
    expect(page).to have_button("Adicionar Questão")
    expect(page).to have_button("Criar")
  end

  scenario "Professor remove uma questão" do
    visit new_formulario_template_path
    click_button "Adicionar Questão"
    expect(page).to have_selector("div#question-1")
    find("#question-1 .remove-button").click
    expect(page).not_to have_selector("div#question-1")
  end


  scenario "Professor tenta criar um template sem questões" do
    visit new_formulario_template_path
    fill_in "template-name", with: "Template Vazio"
    click_button "Criar"
    expect(page.driver.browser.switch_to.alert.text).to eq("O template deve ter pelo menos uma questão.")
    page.driver.browser.switch_to.alert.accept
  end
  
end