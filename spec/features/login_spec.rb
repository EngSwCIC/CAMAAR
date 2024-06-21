require 'rails_helper'

RSpec.feature "Aluno Login", type: :feature do
  let!(:aluno) { FactoryBot.create(:aluno) }
  let!(:professor) { FactoryBot.create(:professor) }

  scenario "Aluno faz login com credenciais válidas" do
    visit new_aluno_session_path
    fill_in 'Email', with: aluno.email
    fill_in 'Password', with: aluno.password
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully.')
  end

  scenario "Aluno tenta fazer login com credenciais inválidas" do
    visit new_aluno_session_path
    fill_in 'Email', with: 'invalid@example.com'
    fill_in 'Password', with: 'invalidpassword'
    click_button 'Log in'
    expect(page).to have_content('Invalid Email or password.')
  end

  scenario "Professor faz login com credenciais válidas" do
    visit new_professor_session_path
    fill_in 'Email', with: professor.email
    fill_in 'Password', with: professor.password
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully.')
  end

  scenario "Professor tenta fazer login com credenciais inválidas" do
    visit new_professor_session_path
    fill_in 'Email', with: 'invalid@example.com'
    fill_in 'Password', with: 'invalidpassword'
    click_button 'Log in'
    expect(page).to have_content('Invalid Email or password.')
  end
end
