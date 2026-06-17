Dado('que eu estou logado como professor') do
  # Implementar quando definir models e autenticação
  # visit '/login'
  # fill_in 'Email', with: 'professor@ufpe.br'
  # fill_in 'Senha', with: 'senha123'
  # click_button 'Entrar'
end

Dado('eu estou na página de criação de formulários') do
  visit '/forms/new'
end

Quando('eu preencho o título com {string}') do |titulo|
  fill_in 'Título do Formulário', with: titulo
end

Quando('eu deixo o título em branco') do
  fill_in 'Título do Formulário', with: ''
end

Quando('eu adiciono uma pergunta do tipo {string} com o texto {string}') do |tipo, texto|
  # Ajustar a interação com os botões/selects dinâmicos na tela quando desenvolvidos
  select tipo, from: 'Tipo de Pergunta'
  fill_in 'Texto da Pergunta', with: texto
  click_button 'Adicionar Pergunta'
end

Quando('eu clico em {string}') do |nome_botao|
  visit root_path unless page.has_button?(nome_botao)
  click_button nome_botao
end

Então('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('eu devo ver o formulário {string} na lista de formulários') do |nome_formulario|
  expect(page).to have_content(nome_formulario)
end
