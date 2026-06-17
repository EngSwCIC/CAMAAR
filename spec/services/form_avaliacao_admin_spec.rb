require 'rails_helper'

RSpec.describe 'Formulário de avaliação do administrador', type: :feature do
  def login_as_admin
    User.create!(
      email: 'admin.teste@unb.br',
      matricula: '000000001',
      password: 'senhaAdmin',
      password_confirmation: 'senhaAdmin',
      role: 'admin',
      nome: 'Admin Teste'
    )

    visit login_path
    fill_in 'email', with: 'admin.teste@unb.br'
    fill_in 'password', with: 'senhaAdmin'
    click_button 'Entrar'
  end

  def visit_send_forms_page
    visit admin_management_path
    click_button 'Enviar Formulários'
    expect(page).to have_selector('.modal')
  end

  def create_template_and_turmas
    @disciplina = Disciplina.create!(code: 'CIC0001', name: 'Engenharia de Software')
    @docente = User.create!(
      email: 'prof.fulano@unb.br',
      matricula: '111000001',
      password: 'senhaDocente',
      password_confirmation: 'senhaDocente',
      role: 'docente',
      nome: 'Prof. Fulano'
    )

    @turma1 = Turma.create!(classCode: 'CIC0105', semester: '2026.1', time: '10:00', disciplina: @disciplina, nome: 'Estudos Em')
    @turma1.docentes << @docente

    @turma2 = Turma.create!(classCode: 'CIC0106', semester: '2026.1', time: '14:00', disciplina: @disciplina, nome: 'Estudos Em')
    @turma2.docentes << @docente

    @template = Template.create!(name: 'Avaliação Engenharia de Software')
    @template.questions.create!(kind: 'radio', text: 'Como você avalia a didática?')
  end

  def select_turma_checkbox(codigo)
    within('.modal table tbody') do
      row = find('tr', text: codigo)
      within(row) do
        find("input[type='checkbox']").check
      end
    end
  end

  scenario 'visualiza modal de envio de formulário com turmas disponíveis', js: true do
    login_as_admin
    visit admin_management_path
    click_button 'Enviar Formulários'

    expect(page).to have_selector('.modal')
    expect(page).to have_select('Template')
    within('.modal table thead') do
      expect(page).to have_content('Nome')
      expect(page).to have_content('Semestre')
      expect(page).to have_content('Código')
    end
    within('.modal table tbody') do
      expect(page).to have_selector('tr')
    end
    expect(page).to have_button('Enviar')
  end

  scenario 'envia formulário para uma turma selecionada', js: true do
    login_as_admin
    create_template_and_turmas
    visit_send_forms_page

    select 'Avaliação Engenharia de Software', from: 'Template'
    select_turma_checkbox('CIC0105')
    click_button 'Enviar'

    expect(page).not_to have_selector('.modal')
    expect(page).to have_content('Formulário enviado com sucesso')
    expect(Form.last.turmas.pluck(:classCode)).to include('CIC0105')
  end

  scenario 'envia formulário para múltiplas turmas simultaneamente', js: true do
    login_as_admin
    create_template_and_turmas
    visit_send_forms_page

    select 'Avaliação Engenharia de Software', from: 'Template'
    select_turma_checkbox('CIC0105')
    select_turma_checkbox('CIC0106')
    click_button 'Enviar'

    expect(page).not_to have_selector('.modal')
    expect(page).to have_content('Formulário enviado com sucesso')
    expect(Form.last.turmas.pluck(:classCode)).to include('CIC0105', 'CIC0106')
  end

  scenario 'formulário enviado aparece disponível para o discente da turma', js: true do
    create_template_and_turmas

    form = Form.create!(template: @template, start_date: 1.day.ago, end_date: 1.day.from_now)
    form.turmas << @turma1

    discente = User.create!(
      email: 'discente.form@gmail.com',
      matricula: '190084020',
      password: 'senhaDicente',
      password_confirmation: 'senhaDicente',
      role: 'discente',
      nome: 'Discente Form'
    )
    discente.turmas << @turma1

    visit login_path
    fill_in 'email', with: 'discente.form@gmail.com'
    fill_in 'password', with: 'senhaDicente'
    click_button 'Entrar'

    visit avaliacoes_path
    expect(page).to have_selector('.turma-card', text: 'CIC0105')
  end

  scenario 'discente responde formulário enviado pelo administrador', js: true do
    create_template_and_turmas

    form = Form.create!(template: @template, start_date: 1.day.ago, end_date: 1.day.from_now)
    form.turmas << @turma1

    discente = User.create!(
      email: 'discente.form@gmail.com',
      matricula: '190084020',
      password: 'senhaDicente',
      password_confirmation: 'senhaDicente',
      role: 'discente',
      nome: 'Discente Form'
    )
    discente.turmas << @turma1

    visit login_path
    fill_in 'email', with: 'discente.form@gmail.com'
    fill_in 'password', with: 'senhaDicente'
    click_button 'Entrar'

    visit avaliacoes_path
    within('.turma-card', text: 'CIC0105') do
      click_on 'CIC0105'
    end

    all('.questao').each do |questao|
      if questao.has_selector?("input[type='radio']")
        questao.first("input[type='radio']").choose
      elsif questao.has_selector?("input[type='text'], textarea")
        questao.first("input[type='text'], textarea").fill_in with: 'Resposta de teste'
      end
    end

    find('.btn-enviar-formulario').click

    expect(FormResponse.count).to be >= 1
    expect(FormResponse.last.user).to eq(discente)

    click_on 'Logout' if page.has_link?('Logout')
    visit login_path
    fill_in 'email', with: 'admin@gmail.com'
    fill_in 'password', with: 'senhaAdmin'
    click_button 'Entrar'
    visit admin_results_path
    expect(page).to have_selector('.turma-card')
  end

  scenario 'não permite enviar formulário sem selecionar um template', js: true do
    login_as_admin
    create_template_and_turmas
    visit_send_forms_page

    select_turma_checkbox('CIC0105')
    click_button 'Enviar'

    expect(page).to have_selector('.modal')
    expect(page).to have_content('Selecione um template para o formulário')
  end

  scenario 'não permite enviar formulário sem selecionar nenhuma turma', js: true do
    login_as_admin
    create_template_and_turmas
    visit_send_forms_page

    select 'Avaliação Engenharia de Software', from: 'Template'
    click_button 'Enviar'

    expect(page).to have_selector('.modal')
    expect(page).to have_content('Selecione ao menos uma turma')
  end

  scenario 'nenhuma turma cadastrada exibe tabela vazia', js: true do
    login_as_admin
    visit admin_management_path
    click_button 'Enviar Formulários'

    within('.modal table tbody') do
      expect(page).not_to have_selector('tr')
    end
    expect(page).to have_content('Nenhuma turma disponível')
    expect(page).to have_button('Enviar', disabled: true)
  end
end
