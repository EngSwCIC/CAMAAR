# Step definitions para features/admin_criar_formulario.feature (#103)

Dado("que sou administrador") do
  @admin = criar_admin
  fazer_login_como(@admin)
end

Dado("que sou um administrador") do
  step "que sou administrador"
end

E("existe pelo menos um template criado por mim") do
  @template = criar_template_com_questao(@admin)
end

E("existe pelo menos uma turma cadastrada") do
  @turma = criar_turma
end

Quando("eu preencher o nome do formulário") do
  visit new_formulario_path
  fill_in "formulario[title]", with: "Avaliação do Semestre"
end

E("selecionar o template e a turma desejada") do
  select @template.title, from: "formulario[template_id]"
  select @turma.name, from: "formulario[course_class_id]"
end

E("clicar no botão 'Enviar'") do
  click_button "Enviar"
end

Então("devo ver uma mensagem dizendo 'Formulário gerado com sucesso!'") do
  expect(page).to have_content("Formulário gerado com sucesso!")
end

E("as questões do template devem ser clonadas para o novo formulário") do
  formulario = Formulario.last
  expect(formulario.questaos.count).to eq(@template.questaos.count)
  expect(formulario.questaos.first.template_id).to be_nil
  expect(formulario.questaos.first.enunciado).to eq(@template.questaos.first.enunciado)
end

E("estou criando um formulário") do
  # A visita à tela acontece depois que as dependências (turma/template) existem,
  # já que o formulário de seleção é montado a partir do estado atual do banco.
end

Quando("eu tentar criar um formulário sem selecionar nenhum template") do
  @turma = criar_turma
  visit new_formulario_path
  fill_in "formulario[title]", with: "Formulário Sem Template"
  select @turma.name, from: "formulario[course_class_id]"
  click_button "Enviar"
end

Quando("eu tentar criar um formulário sem selecionar nenhuma turma") do
  @template = criar_template_com_questao(@admin)
  visit new_formulario_path
  fill_in "formulario[title]", with: "Formulário Sem Turma"
  select @template.title, from: "formulario[template_id]"
  click_button "Enviar"
end

Então("o sistema deve exibir uma mensagem dizendo 'É necessário escolher um template base'") do
  expect(page).to have_content("É necessário escolher um template base")
end

Então("o sistema deve exibir uma mensagem dizendo 'É necessário escolher ao menos uma turma'") do
  expect(page).to have_content("É necessário escolher ao menos uma turma")
end
