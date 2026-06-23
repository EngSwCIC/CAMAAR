# Step definitions para features/admin_editar_deletar_templates.feature (#112)

Dado("que eu editei informações de um template existente") do
  @admin = criar_admin
  @template = criar_template_com_questao(@admin)

  # Formulário gerado a partir da versão ATUAL do template, com questões já clonadas.
  turma = criar_turma
  @formulario = @admin.formularios.create!(title: "Formulário Antigo", template_id: @template.id, course_class_id: turma.id, target_role: @template.target_role)
  @template.questaos.each do |questao|
    @formulario.questaos.create!(enunciado: questao.enunciado, tipo: questao.tipo)
  end
  @enunciado_original_formulario = @formulario.questaos.first.enunciado

  @novo_titulo = "Template Editado #{SecureRandom.hex(4)}"

  fazer_login_como(@admin)
  visit edit_template_path(@template)
  fill_in "template[title]", with: @novo_titulo
end

Quando("eu pressionar o botão {string} na tela de edição") do |texto_botao|
  click_button texto_botao
end

Então("eu devo visualizar as alterações no template na tela de templates") do
  expect(page).to have_text(@novo_titulo)
end

Então("os formulários criados usando a versão antiga não devem sofrer alterações nas suas questões") do
  @formulario.reload
  expect(@formulario.questaos.first.enunciado).to eq(@enunciado_original_formulario)
  expect(@formulario.questaos.first.template_id).to be_nil
end

Dado("que eu escolhi um template na minha lista") do
  @admin = criar_admin
  @template = criar_template_com_questao(@admin)

  turma = criar_turma
  @formulario = @admin.formularios.create!(title: "Formulário Gerado", template_id: @template.id, course_class_id: turma.id, target_role: @template.target_role)
  @template.questaos.each do |questao|
    @formulario.questaos.create!(enunciado: questao.enunciado, tipo: questao.tipo)
  end

  @template_title = @template.title
  fazer_login_como(@admin)
  visit templates_path
end

Quando("eu pressionar o botão de {string}") do |texto|
  click_link texto
end

Então("confirmar a deleção pressionando o botão {string}") do |texto|
  click_button texto
end

Então("esse template não deve aparecer mais na tela de templates") do
  expect(page).not_to have_text(@template_title)
end

Então("os formulários gerados por ele devem permanecer intactos no sistema") do
  @formulario.reload
  expect(@formulario.title).to eq("Formulário Gerado")
  expect(@formulario.template_id).to be_nil
  expect(@formulario.questaos.count).to eq(1)
end

Dado("que estou na página de edição do template") do
  @admin = criar_admin
  @template = criar_template_com_questao(@admin)
  fazer_login_como(@admin)
  visit edit_template_path(@template)
end

Quando("eu clico no botão '+'") do
  click_button "+"
end

Quando("clico no botão 'Confirmar edição'") do
  click_button "Confirmar edição"
end

Então("deve aparecer uma mensagem 'A nova questão não possui enunciado'") do
  expect(page).to have_text("A nova questão não possui enunciado")
end
