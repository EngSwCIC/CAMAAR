Dado('que eu estou logado como aluno') do
  # Implementar quando definir models e autenticação
  # visit '/login'
  # fill_in 'Email', with: 'aluno@ufpe.br'
  # fill_in 'Senha', with: 'senha123'
  # click_button 'Entrar'
end

Dado('existe um formulário ativo chamado {string}') do |nome_formulario|
  # Implementar a criação desse registro (Form/Evaluation) no banco usando Factory/ActiveRecord
end

Dado('eu estou na página de formulários disponíveis') do
  visit '/forms/pending'
end

Quando('eu clico para responder o formulário {string}') do |nome_formulario|
  # Ajustar seletor dependendo da interface, por exemplo, achar o escopo do texto ou tr
  click_link "Responder"
end

Então('eu devo visualizar os detalhes e perguntas pertinentes a ele') do
  # Assumindo que a classe .form-question existirá na view
  expect(page).to have_selector('.form-question')
end

Quando('eu respondo a pergunta {string} com a opção {string}') do |pergunta, opcao|
  # Ajustar conformidade de input visual (radio, select, text)
  choose opcao
end

Quando('eu deixo a pergunta obrigatória {string} em branco') do |pergunta|
  # O comportamento de deixar em branco pode ser simplesmente não preencher, logo, nenhum click extra.
end

Quando('eu clico no botão {string}') do |nome_botao|
  click_button nome_botao
end

Então('o formulário {string} não deve mais aparecer na minha lista de pendentes') do |nome_formulario|
  visit '/forms/pending'
  expect(page).not_to have_content(nome_formulario)
end
