require 'rails_helper'

RSpec.describe 'Template de formulário do administrador', type: :feature do
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

  def visit_templates_page
    visit admin_management_path
    click_button 'Editar Templates'
    expect(page).to have_current_path(admin_templates_path)
  end

  def open_new_template_modal
    find('.template-card-novo', text: '+').click
    expect(page).to have_selector('.modal')
    expect(page).to have_field('Nome do template')
  end

  def create_radio_template(name:, question_text:, options:)
    open_new_template_modal
    fill_in 'Nome do template', with: name
    select 'Radio', from: 'Tipo'
    fill_in 'Texto', with: question_text
    fill_in 'Opções', with: options.first
    within('.modal .questao', match: :first) do
      click_button '+'
    end
    all('.modal .campo-opcao').last.fill_in with: options.last
    click_button 'Criar'
  end

  scenario 'abre o modal de criação de novo template', js: true do
    login_as_admin
    visit_templates_page

    open_new_template_modal
    expect(page).to have_selector('.modal .questao')
    within('.modal .questao', match: :first) do
      expect(page).to have_field('Tipo')
      expect(page).to have_field('Texto')
      expect(page).to have_field('Opções')
    end
    expect(page).to have_button('Criar')
  end

  scenario 'cria um novo template com questão do tipo Radio', js: true do
    login_as_admin
    visit_templates_page

    create_radio_template(
      name: 'Avaliação Engenharia de Software',
      question_text: 'Como você avalia a didática do professor?',
      options: ['Muito bom', 'Bom']
    )

    expect(page).not_to have_selector('.modal')
    expect(page).to have_content('Template criado com sucesso')
    expect(page).to have_selector('.template-card', text: 'Avaliação Engenharia de Software')
  end

  scenario 'cria um novo template com questão do tipo Texto', js: true do
    login_as_admin
    visit_templates_page

    open_new_template_modal
    fill_in 'Nome do template', with: 'Avaliação Aberta'
    select 'Texto', from: 'Tipo'
    fill_in 'Texto', with: 'Deixe seu comentário sobre o professor'
    click_button 'Criar'

    expect(page).not_to have_selector('.modal')
    expect(page).to have_content('Template criado com sucesso')
    expect(page).to have_selector('.template-card', text: 'Avaliação Aberta')
  end

  scenario 'cria um template com múltiplas questões', js: true do
    login_as_admin
    visit_templates_page

    open_new_template_modal
    fill_in 'Nome do template', with: 'Avaliação Completa'
    select 'Radio', from: 'Tipo'
    fill_in 'Texto', with: 'Avalie o desempenho geral'
    click_button '+', match: :first
    within('.modal .questao:nth-child(2)') do
      select 'Texto', from: 'Tipo'
      fill_in 'Texto', with: 'Comentários adicionais'
    end
    click_button 'Criar'

    expect(page).not_to have_selector('.modal')
    template = Template.find_by(name: 'Avaliação Completa')
    expect(template).not_to be_nil
    expect(template.questions.count).to eq(2)
  end

  scenario 'edita um template existente', js: true do
    template = Template.create!(name: 'Avaliação Engenharia de Software', semester: '2024.1')
    template.questions.create!(kind: 'radio', text: 'Como você avalia a didática do monitor?')

    login_as_admin
    visit_templates_page

    within('.template-card', text: 'Avaliação Engenharia de Software') do
      find('.btn-editar').click
    end

    expect(page).to have_selector('.modal')
    expect(find_field('Nome do template').value).to eq('Avaliação Engenharia de Software')

    fill_in 'Nome do template', with: 'Avaliação Engenharia de Software Revisada'
    click_button 'Criar'

    expect(page).not_to have_selector('.modal')
    expect(page).to have_content('Template atualizado com sucesso')
    expect(page).to have_selector('.template-card', text: 'Avaliação Engenharia de Software Revisada')
  end

  scenario 'exclui um template existente', js: true do
    Template.create!(name: 'Avaliação Antiga', semester: '2024.1').questions.create!(kind: 'text', text: 'Comentário')

    login_as_admin
    visit_templates_page

    within('.template-card', text: 'Avaliação Antiga') do
      find('.btn-excluir').click
    end

    expect(page).to have_selector('.modal-confirmacao', text: 'Deseja excluir o template Avaliação Antiga?')
    within('.modal-confirmacao') do
      click_button 'Confirmar'
    end

    expect(page).not_to have_selector('.template-card', text: 'Avaliação Antiga')
  end

  scenario 'não permite criar template sem nome', js: true do
    login_as_admin
    visit_templates_page

    open_new_template_modal
    fill_in 'Nome do template', with: ''
    fill_in 'Texto', with: 'Como você avalia o professor?'
    click_button 'Criar'

    expect(page).to have_selector('.modal')
    expect(page).to have_content('O nome do template é obrigatório')
  end
end
