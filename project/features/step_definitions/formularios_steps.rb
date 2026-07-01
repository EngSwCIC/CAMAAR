# frozen_string_literal: true


# CONTEXTO GERAL E AUTENTICAÇÃO


Dado('que estou logado no sistema como {string}') do |perfil|
  trait = perfil == 'Administrador' ? :admin : nil
  @user = trait ? create(:user, trait) : create(:user)

  visit '/login'
  fill_in 'Email ou matricula', with: @user.email
  fill_in 'Senha', with: 'Senha@123'
  click_button 'Entrar'
end

Dado('que estou autenticado no sistema como participante') do
  step 'que estou logado no sistema como "Participante"'
end


# ISSUE 110: VISUALIZAÇÃO DE FORMULÁRIOS (ADMINISTRADOR)


Quando('eu clico na aba de {string} no menu lateral') do |aba|
  nome_do_link = aba == "Meus Formulários" ? "Gerenciar formularios" : aba
  click_link nome_do_link
end

E('existem formulários previamente criados por mim no sistema') do
  @formularios = create_list(:formulario, 3, admin: @user)
  visit current_path
end

E('eu ainda não criei nenhum formulário no sistema') do
  expect(Formulario.where(admin: @user).count).to eq(0)
end

Então('eu devo ver uma lista com todos os meus formulários publicados') do
  @formularios.each do |formulario|
    expect(page).to have_content(formulario.title)
  end
end

E('a lista deve exibir o título, a turma e o status de cada formulário') do
  @formularios.each do |formulario|
    expect(page).to have_content(formulario.title)
    expect(page).to have_content(formulario.course_class.name)
    expect(page).to have_content(formulario.status || 'Ativo')
  end
end

Então('a lista de formulários deve aparecer vazia') do
  expect(page).not_to have_css('.formulario-item')
end


# ISSUE 109: FORMULÁRIOS PENDENTES (PARTICIPANTE)


Quando('eu acesso a página inicial do meu painel \(Dashboard)') do
  visit formularios_path
end

E('existem formulários ativos das minhas turmas que eu ainda não respondi') do
  @turma = create(:course_class)
  @user.course_classes << @turma
  @formulario_pendente = create(:formulario, course_class: @turma)
  visit current_path
end

E('eu já respondi a todos os formulários ativos das minhas turmas') do
  @turma = create(:course_class)
  @user.course_classes << @turma
  formulario = create(:formulario, course_class: @turma)

  create(:submissao, formulario: formulario, user: @user)
  visit current_path
end

Então('o sistema deve listar os formulários pendentes na seção {string}') do |secao|
  expect(page).to have_content(secao)
  expect(page).to have_content(@formulario_pendente.title)
end

Então('a seção {string} não deve listar nenhum formulário') do |secao|
  expect(page).to have_content(secao)
end

E('cada item da lista deve ter um botão {string}') do |nome_botao|
  expect(page).to have_link(nome_botao)
end


# ISSUE 99: RESPONDER QUESTIONÁRIO


E('que estou na página do formulário não respondido da minha turma') do
  @turma = create(:course_class)
  @user.course_classes << @turma
  @formulario = create(:formulario, :com_questao, course_class: @turma)

  visit formulario_path(@formulario)
end

Quando('eu preencho todas as avaliações corretamente') do
  @formulario.questaos.each do |questao|
    campo = "respostum[respostas][#{questao.id}][valor]"

    case questao.tipo
    when "boolean"
      choose(campo, option: "1")
    when "rating"
      fill_in campo, with: "5"
    else
      fill_in campo, with: "Ótima turma"
    end
  end
end

Quando('eu deixo questões obrigatórias em branco') do
  questao = @formulario.questaos.first
  campo = "respostum[respostas][#{questao.id}][valor]"
  fill_in campo, with: '' unless questao.tipo == "boolean"
end

E('clico no botão de submeter avaliação') do
  click_button 'Enviar Resposta'
end

Então('o sistema deve salvar os {string} vinculados ao meu usuário') do |_|
  expect(Submissao.where(user: @user, formulario: @formulario).count).to eq(1)
  expect(Respostum.count).to eq(1)
end

Então('o sistema não deve processar o envio') do
  expect(Submissao.count).to eq(0)
end

E('eu devo ser redirecionado com uma mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

E('eu devo ver a mensagem de erro {string}') do |mensagem|
  expect(Submissao.count).to eq(0)
  expect(page).to have_content(mensagem)
end

E('o sistema deve exibir a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end


# ISSUE 100: EXPORTAÇÃO DE CSV (ADMIN)


E('que estou na página de visualização de resultados da turma {string}') do |nome_turma|
  @turma = create(:course_class, name: nome_turma)
  @formulario = create(:formulario, admin: @user, course_class: @turma)
  visit formulario_path(@formulario)
end

E('que estou na página de visualização de resultados de um formulário recém-criado') do
  @formulario = create(:formulario, admin: @user)
  visit formulario_path(@formulario)
end

Quando('o formulário selecionado já possui respostas submetidas') do
  aluno = create(:user)
  create(:submissao, formulario: @formulario, user: aluno)
  visit formulario_path(@formulario) # <--- Força o recarregamento explícito da página
end

Quando('o formulário selecionado ainda não possui nenhuma resposta de participante') do
  expect(Submissao.where(formulario_id: @formulario.id).count).to eq(0)
end

E('eu clico no botão {string}') do |texto_botao|
  if page.has_link?(texto_botao)
    click_link texto_botao
  elsif page.has_button?(texto_botao)
    click_button texto_botao
  end
end

Então('o sistema deve gerar um arquivo {string} com todas as respostas estruturadas') do |_|
  expect(page.response_headers['Content-Type']).to include('text/csv')
end

E('o download do arquivo deve iniciar automaticamente no meu navegador') do
  expect(page.response_headers['Content-Disposition']).to include('attachment')
  expect(page.response_headers['Content-Disposition']).to include(".csv")
end

Então('o sistema não deve gerar o arquivo') do
  expect(page.response_headers['Content-Type']).not_to include('text/csv')
end

E('deve exibir um alerta impeditivo {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end
