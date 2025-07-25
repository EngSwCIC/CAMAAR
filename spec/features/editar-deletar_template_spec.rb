# spec/features/editar_deletar_template_spec.rb
require "rails_helper"

RSpec.feature "Manage form templates", type: :feature do
  let!(:admin) { User.create!(nome: "Admin", email: "admin@teste.com", password: "123456", ocupacao: "admin") }

  background do
  visit login_path
  fill_in "Email", with: "admin@teste.com"
  fill_in "Senha", with: "123456"
  click_button "Entrar"

  Template.create!(
    name: "Avaliação Semestral",
    description: "Avaliação geral do semestre letivo",
    user: admin,
    template_questions_attributes: [{
      question_text: "Como você avalia a disciplina?",
      question_type: "text",
      required: true
    }]
  )

  Template.create!(
    name: "Avaliação de matéria",
    description: "Avaliação da matéria específica",
    user: admin,
    template_questions_attributes: [{
      question_text: "Qual sua opinião sobre o conteúdo?",
      question_type: "text",
      required: true
    }]
  )
end

  scenario "Edit a template without affecting existing forms" do
    visit admin_templates_path
    within(:xpath, "//h3[contains(text(), 'Avaliação Semestral')]/ancestor::div[contains(@class, 'bg-white')]") do
      click_link "Editar"
    end

    fill_in "Descrição", with: "Nova descrição do semestre"
    click_button "Salvar Alterações"

    #expect(page).to have_content("Template atualizado!")
    expect(page).to have_content("Nova descrição do semestre")
  end

  #scenario "Delete a template without affecting existing forms" do
    #visit admin_templates_path
    #within(:xpath, "//h3[contains(text(), 'Avaliação semestral')]/ancestor::div[contains(@class, 'bg-white')]") do
     # accept_confirm { click_link "Excluir" }
    #end

    #expect(page).to have_content("Template removido")
    #expect(page).not_to have_content("Avaliação semestral")
  #end

  #scenario "Try to delete a already deleted template" do
   # visit admin_templates_path
    #within(:xpath, "//h3[contains(text(), 'Avaliação Semestral')]/ancestor::div[contains(@class, 'bg-white')]") do
     # accept_confirm { click_link "Excluir" }
    #end

    # Força a tentativa de deletar novamente sem recarregar
    #expect do
     # within("tr", text: "Avaliação semestral") do
      #  click_link "Excluir"
      #nd
    #end.to raise_error(Capybara::ElementNotFound)
  #end
end
