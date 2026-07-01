# encoding: utf-8
# Steps genéricos compartilhados entre todas as features

# ==================== CAMPOS E BOTÕES ====================

Quando('preencho o campo {string} com {string}') do |campo, valor|
  fill_in campo, with: valor
end

Quando('deixo o campo {string} em branco') do |campo|
  fill_in campo, with: ''
end

Então('vejo a mensagem de sucesso {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('vejo o botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

# ==================== MODAL ====================

Então('o modal é fechado') do
  expect(page).not_to have_selector('.modal')
end

Então('o modal permanece aberto') do
  expect(page).to have_selector('.modal')
end

# ==================== AUTENTICAÇÃO (roles reutilizáveis) ====================

Dado('que estou logado como Discente') do
  @discente_user = User.create!(
    email:                 'discente.teste@gmail.com',
    matricula:             '190099999',
    password:              'senhaDicente',
    password_confirmation: 'senhaDicente',
    role:                  'discente'
  )
  visit login_path
  fill_in 'Email ou Matrícula', with: 'discente.teste@gmail.com'
  fill_in 'Senha',              with: 'senhaDicente'
  click_button 'Entrar'
end

Dado('que estou logado como Dicente') do
  @dicente = User.create!(
    email:                 'dicente@gmail.com',
    matricula:             '190084009',
    password:              'senhaDicente',
    password_confirmation: 'senhaDicente',
    role:                  'discente'
  )
  visit login_path
  fill_in 'Email ou Matrícula', with: 'dicente@gmail.com'
  fill_in 'Senha',              with: 'senhaDicente'
  click_button 'Entrar'
end

# ==================== NAVEGAÇÃO GENÉRICA ====================

Quando('acesso a página {string}') do |pagina|
  case pagina
  when 'Avaliações'
    visit avaliacoes_path
  when 'Gerenciamento - Turmas'
    visit admin_classes_path
  when 'Gerenciamento - Resultados'
    visit admin_results_path
  when 'Gerenciamento - Templates'
    visit admin_templates_path
  when 'Gerenciamento - Formulários Ativos'
    visit admin_forms_path
  when 'de templates'
    if defined?(@simulate_template_error) && @simulate_template_error
      visit templates_path(simulate_error: true)
    else
      visit templates_path
    end
  else
    visit '/'
  end
end

Quando('tento acessar a página {string}') do |pagina|
  case pagina
  when 'Gerenciamento'
    visit admin_management_path
  when 'Gerenciamento - Templates'
    visit admin_templates_path
  when 'Gerenciamento - Resultados'
    visit admin_results_path
  when 'Gerenciamento - Turmas'
    visit admin_classes_path
  when 'de templates'
    visit templates_path
  else
    visit '/'
  end
end

# ==================== REDIRECIONAMENTOS ====================

Então('sou redirecionado para o painel do usuário') do
  expect(page).to have_current_path(avaliacoes_path, wait: 10)
end

Então('sou redirecionado para a página {string}') do |pagina|
  case pagina
  when 'Gerenciamento - Templates'
    expect(page).to have_current_path(admin_templates_path, wait: 10)
  when 'Gerenciamento - Turmas'
    expect(page).to have_current_path(admin_classes_path, wait: 10)
  when 'Gerenciamento - Resultados'
    expect(page).to have_current_path(admin_results_path, wait: 10)
  when 'Avaliações'
    expect(page).to have_current_path(avaliacoes_path, wait: 10)
  else
    expect(page).to have_current_path('/', wait: 10)
  end
end

# ==================== FILTROS GENÉRICOS ====================

Quando('seleciono a turma {string} no filtro') do |turma|
  select turma, from: 'filtro_turma'
end

Quando('seleciono {string} no filtro {string}') do |opcao, filtro|
  select opcao, from: filtro
end

Quando('seleciono o template {string} no dropdown {string}') do |template, campo|
  within('.modal') do
    select template, from: campo
  end
end

Quando('não seleciono nenhum template no dropdown {string}') do |campo|
  within('.modal') do
    expect(find("select[name='template_id']").value).to be_blank
  end
end

Quando('clico no cabeçalho da coluna {string}') do |coluna|
  find('th', text: coluna).click
end

# ==================== FORMULÁRIOS PARA DOCENTES ====================

Então('os formulários para docentes deixam de aparecer') do
  expect(page).not_to have_content('Docentes')
end
