# encoding: utf-8

# ==================== CONTEXTO ====================

# Dado('que estou logado como Administrador')
# Dado('estou na página {string}')
# Dado('clico no botão {string}')
# Então('vejo a mensagem de sucesso {string}')
# Então('vejo a mensagem de erro {string}')
# Então('sou redirecionado para o painel do usuário')

Dado('que existem templates de avaliação cadastrados no sistema') do
  template = Template.create!(name: 'Avaliação de Monitoria', semester: '2024.1')
  template.questions.create!(kind: 'text', text: 'Comentários gerais')
end

Dado('que existe o card do template {string} na listagem') do |nome_template|
  @template_existente = Template.create!(
    name:     nome_template,
    semester: '2024.1'
  )
  @template_existente.questions.create!(
    kind: 'radio',
    text: 'Como você avalia a didática do monitor?',
    options: ['Muito bom', 'Bom']
  )
  @template_existente.questions.create!(
    kind: 'text',
    text: 'Comentários adicionais'
  )
  visit admin_templates_path
end

Dado('que já existe um template com o nome {string}') do |nome_template|
  Template.create!(
    name:     nome_template,
    semester: '2024.1'
  )
  visit admin_templates_path
end

# ==================== AÇÕES — NAVEGAÇÃO E MODAL ====================

Então('vejo os templates existentes exibidos em cards com nome e semestre') do
  expect(page).to have_selector('.template-card')
  within('.template-card', match: :first) do
    expect(page).to have_selector('.template-nome')
    expect(page).to have_selector('.template-semestre')
  end
end

Então('cada card possui os ícones de editar e excluir') do
  within('.template-card', match: :first) do
    expect(page).to have_selector('.btn-editar')
    expect(page).to have_selector('.btn-excluir')
  end
end

Então('vejo um card com o símbolo {string} para criar um novo template') do |simbolo|
  expect(page).to have_selector('.template-card-novo', text: simbolo)
end

Quando('clico no card {string}') do |simbolo|
  find('.template-card-novo', text: simbolo).click
end

Então('um modal é exibido com o campo {string}') do |campo|
  expect(page).to have_selector('.modal')
  expect(page).to have_field(campo)
end

Então('o modal contém ao menos uma questão com os campos {string}, {string} e {string}') do |campo1, campo2, campo3|
  within('.modal .questao', match: :first) do
    expect(page).to have_field(campo1)
    expect(page).to have_field(campo2)
    expect(page).to have_field(campo3)
  end
end

# ==================== AÇÕES — PREENCHIMENTO DO MODAL ====================

Quando('seleciono o tipo {string} na {string}') do |tipo, questao|
  numero = questao.gsub(/\D/, '')
  within(".modal .questao:nth-child(#{numero})") do
    select tipo, from: 'Tipo'
  end
end

Quando('preencho o campo {string} da {string} com {string}') do |campo, questao, valor|
  numero = questao.gsub(/\D/, '')
  within(".modal .questao:nth-child(#{numero})") do
    fill_in campo, with: valor
  end
end

Quando('clico no botão {string} dentro da {string} para adicionar mais uma opção') do |botao, questao|
  numero = questao.gsub(/\D/, '')
  within(".modal .questao:nth-child(#{numero})") do
    find('.btn-add-opcao', text: botao).click
  end
end

Quando('preencho a nova opção com {string}') do |valor|
  # Preenche o último campo de opção criado dinamicamente
  all('.modal .campo-opcao').last.fill_in with: valor
end

Quando('clico no botão {string} roxo para adicionar uma nova questão') do |botao|
  within('.modal') do
    find('.btn-add-questao', text: botao).click
  end
end

Quando('deixo o campo {string} da {string} em branco') do |campo, questao|
  numero = questao.gsub(/\D/, '')
  within(".modal .questao:nth-child(#{numero})") do
    fill_in campo, with: ''
  end
end

Quando('deixo o campo de opções {string} em branco') do |campo|
  if campo == 'Opções'
    # Campo de opções fica vazio — não preenche nada
    within('.modal .questao', match: :first) do
      fill_in 'Opções', with: ''
    end
  elsif campo == 'Tipo de Destinatário'
    find('#destinatario').select('Selecione')
  else
    fill_in campo, with: ''
  end
end

# ==================== AÇÕES — EDITAR E EXCLUIR ====================

Quando('clico no ícone de editar do template {string}') do |nome_template|
  within('.template-card', text: nome_template) do
    find('.btn-editar').click
  end
end

Então('o modal de edição é exibido com os dados atuais do template preenchidos') do
  expect(page).to have_selector('.modal')
  expect(find_field('Nome do template').value).to eq(@template_existente.name)
end

Quando('altero o campo {string} para {string}') do |campo, valor|
  within('.modal') do
    fill_in campo, with: valor
  end
end

Quando('clico no ícone de excluir do template {string}') do |nome_template|
  within('.template-card', text: nome_template) do
    find('.btn-excluir').click
  end
end

Então('vejo uma mensagem de confirmação {string}') do |mensagem|
  expect(page).to have_selector('.modal-confirmacao', text: mensagem)
end

Quando('confirmo a exclusão') do
  within('.modal-confirmacao') do
    click_button 'Confirmar'
  end
end

# ==================== VERIFICAÇÕES — CENÁRIOS FELIZES ====================

Então('o template {string} aparece na listagem de cards') do |nome_template|
  expect(page).to have_selector('.template-card', text: nome_template)
end

Então('o template {string} é salvo com {int} questões') do |nome_template, quantidade|
  template = Template.find_by(name: nome_template)
  expect(template).not_to be_nil
  expect(template.questions.count).to eq(quantidade)
end

Então('o template {string} passa a ter {int} questões') do |nome_template, quantidade|
  template = Template.find_by(name: nome_template)
  expect(template.questions.reload.count).to eq(quantidade)
end

Então('o card {string} aparece na listagem') do |nome_template|
  expect(page).to have_selector('.template-card', text: nome_template)
end

Então('o card {string} é removido da listagem') do |nome_template|
  expect(page).not_to have_selector('.template-card', text: nome_template)
end
