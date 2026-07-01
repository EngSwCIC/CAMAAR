# frozen_string_literal: true

Given(/^estou na página "([^"]+)"$/) do |pagina|
  estado[:pagina_atual] = pagina
end

When(/^eu acesso a página de criação de formulário$/) do
  estado[:pagina_atual] = :criacao_formulario
end

When(/^eu acesso a página de gerenciamento de turmas$/) do
  estado[:pagina_atual] = :gerenciamento_turmas
end

When(/^eu acesso o link de redefinição do e-mail dentro do prazo de validade$/) do
  estado[:pagina_atual] = :redefinicao_senha
end

When(/^eu tento acessar o link de redefinição contido no e-mail$/) do
  estado[:pagina_atual] = :solicitacao_redefinicao
  return unless estado[:redefinicao_token]&.expirado?

  estado[:mensagens] << "O link de redefinição é inválido, expirou ou não corresponde a esta operação."
end

When(/^eu tento acessar o formulário "([^"]+)"$/) do |formulario|
  formulario = estado[:formularios_por_nome].fetch(formulario)

  if Formulario.do_departamento(adm_atual.departamento).exists?(formulario.id)
    estado[:formulario_acessado] = formulario
  else
    estado[:mensagens] << "Você não tem permissão para acessar esse formulário."
  end
end

When(/^eu tento exportar os resultados do formulário "([^"]+)"$/) do |formulario|
  formulario = estado[:formularios_por_nome].fetch(formulario)

  if Formulario.do_departamento(adm_atual.departamento).exists?(formulario.id)
    estado[:csv_baixado] = true
  else
    estado[:csv_baixado] = false
    estado[:mensagens] << "Você não tem permissão para exportar os resultados desse formulário."
  end
end

When(/^seleciono o template "([^"]+)"$/) do |titulo|
  estado[:template_selecionado] = Template.find_by!(titulo: titulo)
end

When(/^seleciono a turma "([^"]+)" da matéria "([^"]+)"$/) do |numero, materia|
  estado[:turma_selecionada] = turma_da_materia(numero, materia)
end

When(/^seleciono o público-alvo "([^"]+)"$/) do |publico|
  estado[:publico_alvo] = publico
end

def confirm_form_creation
  turma = estado.fetch(:turma_selecionada)
  template = estado.fetch(:template_selecionado)
  publico = estado.fetch(:publico_alvo, "discentes")

  if turma.departamento_id != adm_atual.departamento_id
    estado[:mensagens] << "não tenho permissão para gerenciar essa turma"
    return
  end

  estado[:formulario_criado] = Formulario.create!(
    adm: adm_atual,
    turma: turma,
    template: template,
    publico_alvo: publico
  ).tap do |formulario|
    copiar_questoes_do_template_para_formulario(formulario, template)
  end
  estado[:mensagens] << "o formulário foi criado com sucesso"
end

When(/^confirmo a criação do formulário$/) do
  confirm_form_creation
end

When(/^pressiono o botão "Criar Formulário"$/) do
  confirm_form_creation
end

Then(/^devo ver uma mensagem informando que o formulário foi criado com sucesso$/) do
  expect(estado[:mensagens]).to include("o formulário foi criado com sucesso")
end

Then(/^devo ver uma mensagem informando que não tenho permissão para gerenciar essa turma$/) do
  expect(estado[:mensagens]).to include("não tenho permissão para gerenciar essa turma")
end

Then(/^devo ver uma mensagem informando que não tenho permissão para acessar esse formulário$/) do
  expect(estado[:mensagens]).to include("Você não tem permissão para acessar esse formulário.")
end

Then(/^devo ver uma mensagem informando que não tenho permissão para exportar os resultados desse formulário$/) do
  expect(estado[:mensagens]).to include(
    "Você não tem permissão para exportar os resultados desse formulário."
  )
end

Then(/^nenhum arquivo CSV deve ser baixado$/) do
  expect(estado[:csv_baixado]).to be(false)
end
