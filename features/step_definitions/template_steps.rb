Given(/^I [aA]m authenticated as an "([^"]*)"$/) do |role|
  depto = Departamento.find_or_create_by!(nome: 'Departamento', codigo: 'TST')

  @admin = Administrador.find_or_create_by!(email: 'admin@unb.br') do |u|
    u.senha_hash = '123456'
    u.nome = 'Admin'
    u.matricula = '123456789'
    u.departamento = depto
  end

  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

  allow_any_instance_of(TemplatesController).to receive(:set_admin) do |controller|
    controller.instance_variable_set(:@admin, @admin)
  end
end

Given('I Am on the home page') do
  visit inicio_path
end

Given('I go to the {string} page') do |page|
  admin = Administrador.first
  visit admin_templates_path(admin) if page == "Meus Templates"
end

Given('I am on the {string} page') do |page_name|
  expect(page).to have_content("Nome do template:")
end

When('I follow {string}') do |link|
  if link == "Adicionar novo template"
    admin = Administrador.first
    visit new_admin_template_path(admin)
  else
    click_link_or_button(link)
  end
end

When('I follow {string} for {string}') do |acao, template_nome|
  card = find('.card', text: template_nome)
  card.find("[aria-label='#{acao}']").click
end

When('I press {string}') do |botao|
  if page.has_button?('Criar')
    click_button 'Criar'
  else
    click_button 'Salvar'
  end
end

When('I confirm the deletion') do
end

Given('I have added the template') do |table|
  dados = table.rows_hash
  valor = dados['titulo'].gsub(/^"|"$/, '')
  fill_in "Nome do template:", with: valor
end

Given('I add the following elementos:') do |table|
  table.hashes.each_with_index do |row, index|
    find('.add-question-btn', visible: :all).click if index > 0

    within all('.question-block:not(.deleted-block)').last do
      find('.figma-input-line-full[placeholder="Digite a pergunta..."]').set(row['enunciado_elemento'])

      tipo = row['tipo_campo'] == 'multipla_escolha' ? 'Múltipla Escolha' : 'Texto'
      find('.select-tipo').find("option[value='#{tipo}']").select_option

      if tipo == 'Múltipla Escolha'
        opcoes = row['enunciado_campo'].split(':').map(&:strip).reject(&:empty?)
        opcoes.each_with_index do |opcao, opt_idx|
          find('.btn-add-option').click if opt_idx > 0
          all('.option-row:not(.deleted-option) input.figma-input-line-full').last.set(opcao)
        end
      end
    end
  end
end

Given('I dont add elementos') do
  find('input.destroy-question-input', visible: :hidden).set('1')
end

When('I change the {string} to {string}') do |campo, valor|
  fill_in "Nome do template:", with: valor if campo == "titulo"
end

When('I change the elemento {string} to {string}') do |antigo, novo|
  if novo.empty?
    input = find("input.figma-input-line-full[value='#{antigo.strip}']")
    bloco = input.ancestor('.question-block')
    within(bloco) do
      find('input.destroy-question-input', visible: :hidden).set('1')
    end
  else
    input = find("input.figma-input-line-full[value='#{antigo.strip}']")
    input.set(novo)
  end
end

Then('I should see a success message {string}') do |msg|
  expect(page).to have_content(msg)
end

Then('I should see an error message {string}') do |msg|
  expect(page).to have_content(msg)
end

Then('the template {string} should be listed in my templates') do |nome|
  expect(page).to have_content(nome)
end

Then('I should see {string}') do |texto|
  expect(page).to have_content(texto)
end

Then('I should not see {string}') do |texto|
  expect(page).not_to have_content(texto)
end

Then('I should see the message {string}') do |msg|
  expect(page).to have_content(msg)
end

Then('I should see options to {string} and {string} for each template') do |acao1, acao2|
  expect(page).to have_selector("[aria-label='#{acao1}']")
  expect(page).to have_selector("[aria-label='#{acao2}']")
end

Then('I should see a button {string}') do |botao|
  expect(page).to have_selector("a, button", text: botao)
end

Then('the template {string} should have the following elementos:') do |nome, table|
  template = Template.find_by(nome: nome)
  expect(template.elementos.count).to eq(table.hashes.count)
end

Given('I have the following templates saved:') do |table|
  admin = Administrador.first
  table.hashes.each do |row|
    template = Template.new(nome: row['titulo'], administrador: admin)
    elemento = template.elementos.build(enunciado: "Questão Fantasma", ordem: 1)
    elemento.campos.build(tipo_elemento: "Texto", ordem: 1)
    template.save!
  end
end

Given('the template {string} has the following elementos:') do |nome, table|
  template = Template.find_by(nome: nome)
  template.elementos.destroy_all # Limpa a fantasma

  table.hashes.each_with_index do |row, index|
    tipo = row['tipo_campo'] == 'multipla_escolha' ? 'Múltipla Escolha' : 'Texto'
    elemento = template.elementos.create!(enunciado: row['enunciado_elemento'], ordem: index + 1)

    if tipo == 'Múltipla Escolha'
      opcoes = row['enunciado_campo'].split(':').map(&:strip).reject(&:empty?)
      opcoes.each_with_index do |opcao, opt_idx|
        elemento.campos.create!(tipo_elemento: tipo, enunciado: opcao, ordem: opt_idx + 1)
      end
    else
      elemento.campos.create!(tipo_elemento: tipo, ordem: 1)
    end
  end
end

Given('I have no templates saved') do
  Template.destroy_all
end
