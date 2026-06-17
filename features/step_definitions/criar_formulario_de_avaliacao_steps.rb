Dado('que eu acesse a tela de {string}') do |_tela|
  @admin = Pessoa.create!(usuario: "admin_avaliacao", password: "123", password_confirmation: "123", nome: "Admin", admin: true)
  pessoa_prof = Pessoa.create!(usuario: "prof_avaliacao", password: "123", password_confirmation: "123", nome: "Professor Avaliacao")
  docente = Docente.create!(pessoa: pessoa_prof)
  disciplina = Disciplina.create!(nome: "Engenharia de Software", codigo: "CIC0001")
  @turma = Turma.create!(codigo: "TA", disciplina: disciplina, docente: docente)
  
  @template = Template.create!(nome: "Avaliação Padrão de Semestre", pessoa: @admin)
  TemplateQuestao.create!(template: @template, enunciado: "Questão teste", tipo_resposta: "texto") # <-- ADICIONADO AQUI
  
  visit login_path
  fill_in 'login', with: @admin.usuario
  fill_in 'password', with: '123'
  click_button 'Entrar'
  visit new_admin_formulario_path
end

Quando('eu selecionar o template existente {string}') do |nome_template|
  select nome_template, from: 'template_id'
end

Quando('eu deixar o campo de seleção de template em branco') do
  select 'Selecione um template...', from: 'template_id'
end

Quando('clicar em {string}') do |botao|
  click_button botao
end

Então('o sistema deve salvar o formulário com sucesso') do
  expect(Formulario.where(turma: @turma, template: @template)).to exist
end

Então('o formulário deve ficar disponível para a turma escolhida') do
  formulario = Formulario.last
  expect(formulario.turma).to eq(@turma)
end

Então('o sistema não deve permitir a publicação') do
  expect(Formulario.count).to eq(0)
end
