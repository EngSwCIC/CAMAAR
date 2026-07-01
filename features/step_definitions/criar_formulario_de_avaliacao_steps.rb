Dado('que eu acesse a tela de {string}') do |_tela|
  @admin = Pessoa.create!(usuario: "admin_avaliacao", email: "admin_avaliacao@unb.br", password: "123", password_confirmation: "123", nome: "Admin", admin: true)
  pessoa_prof = Pessoa.create!(usuario: "prof_avaliacao", email: "prof_avaliacao@unb.br", password: "123", password_confirmation: "123", nome: "Professor Avaliacao")
  docente = Docente.create!(pessoa: pessoa_prof)
  disciplina = Disciplina.create!(nome: "Engenharia de Software", codigo: "CIC0001")
  @turma = Turma.create!(codigo: "TA", disciplina: disciplina, docente: docente)
  @template = Template.create!(nome: "Avaliação Padrão de Semestre", pessoa: @admin)
  TemplateQuestao.create!(template: @template, enunciado: "Questão teste", tipo_resposta: "texto")
  
  visit login_path
  fill_in 'login', with: @admin.email
  fill_in 'password', with: '123'
  click_button 'Entrar'
  visit new_admin_formulario_path
end

Quando('eu selecionar o template existente {string}') do |nome_template|
  find("select[name='template_id']").all('option').last.select_option
end

Quando('eu deixar o campo de seleção de template em branco') do
  find("select[name='template_id']").all('option').first.select_option
end

Quando('clicar em {string}') do |botao|
  find("input[type='submit']").click
end

Então('o sistema deve salvar o formulário com sucesso') do
  expect(page).to have_content(/sucesso/i, wait: 5)
  expect(Formulario.count).to be > 0
end

Então('o formulário deve ficar disponível para a turma escolhida') do
  expect(Formulario.last.turma).to eq(@turma)
end

Então('o sistema não deve permitir a publicação') do
  expect(Formulario.count).to eq(0)
end