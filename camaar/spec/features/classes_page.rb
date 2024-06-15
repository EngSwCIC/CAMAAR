require 'rails_helper'

feature 'Visualize classes from classes page' do
  background do
    # will clear the message queue
    departament = create(:department, :departament1)
  end

  describe 'when there are classes' do
    scenario 'admin can visualize classes' do
      admin = create(:admin, :admin1)
      coordinator = create(:coordinator, :coordinator1)
      user = create(:user, :user5)
      teacher = create(:teacher, :teacher1)
      class1 = create(:subject_class, :subject_class1)
      class2 = create(:subject_class, :subject_class2)
      class3 = create(:subject_class, :subject_class3)

      visit '/admins/login'

      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'
      expect(page).to have_content 'Turmas'
      click_link 'Turmas'

      expect(page).to have_content 'DEPTO CIÊNCIAS DA COMPUTAÇÃO'
      expect(page).to have_content 'BANCOS DE DADOS'
      expect(page).to have_content 'ENGENHARIA DE SOFTWARE'
      expect(page).to have_content 'PROGRAMAÇÃO CONCORRENTE'
      expect(page).to have_content '2021.2'
      expect(page).to have_content 'CIC0097'
      expect(page).to have_content 'CIC0105'
      expect(page).to have_content 'CIC0202'
      expect(page).to have_content 'TA'
      expect(page).to have_content '35T45'
      expect(page).to have_content '35M12'
      expect(page).to have_content '35M34'
    end
  end
  describe 'when there are no classes' do
    scenario 'admin can not visualize classes if there are no classes' do
      admin = create(:admin, :admin1)
      coordinator = create(:coordinator, :coordinator1)
      user = create(:user, :user5)
      teacher = create(:teacher, :teacher1)

      visit '/admins/login'

      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'
      expect(page).to have_content 'Turmas'
      click_link 'Turmas'

      expect(page).to have_content 'O departamento não possui turmas'
    end
  end
end
