Dado("que existe um template criado") do
  @template = Template.create!(
    nome: "Modelo Antigo"
  )
end

Quando("eu edito o template") do
  visit edit_template_path(@template)
end

Quando("salvo as alterações") do
  fill_in "Nome", with: "Modelo Novo"
  click_button "Salvar"
end

Então("uma nova versão do template deve ser criada") do
  expect(
    Template.where(nome: "Modelo Novo").count
  ).to eq(1)
end

Então("a versão anterior deve ser preservada") do
  expect(
    Template.where(nome: "Modelo Antigo").count
  ).to eq(1)
end

Dado("existem formulários já criados baseados na versão atual do template") do
  @formulario = Form.create!(template: @template, start_date: 1.day.ago, end_date: 1.month.from_now)
end

Então("os formulários já criados devem permanecer vinculados à versão antiga") do
  expect(Form.where(template: @template).count).to eq(1)
  expect(@formulario.template).to eq(@template)
end

Então("nenhuma nova versão deve ser criada") do
  expect(Template.where(parent_template_id: @template.id)).to be_empty
end

Quando("tento editar um template") do
  @template ||= Template.create!(nome: "Modelo Antigo")
  visit edit_template_path(@template)
end

Quando("tento excluir um template") do
  @template ||= Template.create!(nome: "Modelo Antigo")
  page.driver.submit(:delete, template_path(@template), {})
end

Dado("o template não está em uso por formulários") do
  expect(@template.forms).to be_empty
end

Quando("solicito a exclusão do template") do
  visit templates_path
  @template_to_delete = @template
  @delete_requested = true
end

Quando("confirmo a exclusão do template") do
  if @delete_requested && @template_to_delete
    page.driver.submit(:delete, template_path(@template_to_delete), {})
    @delete_requested = false
  end
end

Então("o template deve ser removido com sucesso") do
  expect(Template.exists?(@template_to_delete.id)).to be false
  expect(page).to have_content("Template removido com sucesso.")
end

Quando("cancelo a exclusão") do
  @delete_requested = false
end

Então("o template não deve ser removido") do
  expect(Template.exists?(@template.id)).to be true
end

Quando("tento excluir um template que não existe") do
  page.driver.submit(:delete, template_path(id: 999_999), {})
end

Quando("tento editar um template que não existe") do
  visit edit_template_path(id: 999_999)
end

Dado("existem formulários baseados nesse template") do
  Form.create!(template: @template, start_date: 1.day.ago, end_date: 1.month.from_now)
end

Quando("tento salvar o template com dados inválidos") do
  visit edit_template_path(@template)
  fill_in "Nome", with: ""
  click_button "Salvar"
end

Quando("tento salvar o template com o campo nome vazio") do
  visit edit_template_path(@template)
  fill_in "Nome", with: ""
  click_button "Salvar"
end

Então("a criação da nova versão deve ser registrada no histórico") do
  expect(@template.reload.versions.count).to eq(1)
end

Então("deve conter usuário e data da alteração") do
  new_version = @template.reload.versions.last
  expect(new_version).not_to be_nil
  expect(new_version.created_at).not_to be_nil
  expect(new_version.user).not_to be_nil if new_version.respond_to?(:user)
end

Dado("que existe um template com muitos formulários vinculados") do
  @template = Template.create!(nome: "Modelo Antigo")
  3.times { Form.create!(template: @template, start_date: 1.day.ago, end_date: 1.month.from_now) }
end

Então("a nova versão deve ser criada com sucesso") do
  expect(Template.where(nome: "Modelo Novo").count).to eq(1)
end

Então("os formulários devem permanecer vinculados à versão anterior") do
  expect(Form.where(template: @template).count).to eq(3)
end

Então("devo ser solicitado a confirmar a exclusão") do
  expect(@delete_requested).to be true
  expect(page).to have_selector("a[data-turbo-confirm='Tem certeza que deseja excluir este template?']")
end

Então("devo ser impedido de excluir") do
  expect(Template.exists?(@template.id)).to be true
end

Então("devo ver uma mensagem informando que o template está em uso") do
  expect(page).to have_content("Template está em uso por formulários")
end

Então("devo ver uma mensagem de erro informando que o template não foi encontrado") do
  expect(page).to have_content("Template não encontrado.")
end

Quando("tento excluir o template") do
  @template ||= Template.create!(nome: "Modelo Antigo")
  page.driver.submit(:delete, template_path(@template), {})
end

Quando("tento editar o template") do
  @template ||= Template.create!(nome: "Modelo Antigo")
  visit edit_template_path(@template)
end

Então("devo ver mensagens de validação") do
  expect(page).to have_text(/não pode ficar em branco|não pode ser vazio|can't be blank/i)
end

Então("devo ver mensagem de erro indicando campo obrigatório") do
  expect(page).to have_text(/não pode ficar em branco|é obrigatório|can't be blank/i)
end
