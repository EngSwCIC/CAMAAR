# frozen_string_literal: true

def preparar_formulario_de_template
  estado[:template_form] = {
    titulo: nil,
    descricao: nil,
    questoes: []
  }
end

def template_params_do_formulario
  {
    template: {
      titulo: estado[:template_form][:titulo],
      descricao: estado[:template_form][:descricao],
      utilizacoes_questoes_attributes: estado[:template_form][:questoes]
        .each_with_index
        .map do |questao, index|
          {
            numero: index + 1,
            questao_attributes: questao_attributes(
              enunciado: questao.fetch(:enunciado),
              tipo: questao.fetch(:tipo),
              opcoes: questao.fetch(:opcoes, [])
            )
          }
        end
    }
  }
end

def mensagem_de_erro_do_template(template)
  return "o título do template é obrigatório" if template.errors[:titulo].any?

  if template.errors[:utilizacoes_questoes].any?
    return "o template deve possuir pelo menos uma questão"
  end

  template.errors.full_messages.to_sentence
end

When(/^eu acesso a página de criação de template$/) do
  preparar_formulario_de_template

  if TemplatePolicy.new(usuario_atual, Template.new(adm: adm_atual)).create?
    visit new_template_path
  else
    estado[:mensagens] << "não tenho permissão para criar templates"
  end
end

Given(/^que existe um template chamado "([^"]+)" criado por outro administrador$/) do |titulo|
  outro_admin = usuario_administrador(departamento: "Outro Departamento")
  estado[:template_de_outro_administrador] = template_com_titulo(
    titulo,
    adm: outro_admin.perfil_adm
  )
end

When(/^eu tento acessar a página de criação de template$/) do
  preparar_formulario_de_template

  unless TemplatePolicy.new(usuario_atual, Template.new(adm: adm_atual)).create?
    estado[:formulario_visivel] = false
    estado[:mensagens] << "não tenho permissão para criar templates"
    next
  end

  estado[:formulario_visivel] = true
  visit new_template_path
end

When(/^eu acesso a página de templates$/) do
  visit templates_path
  estado[:templates_visiveis] = TemplatePolicy.scope(usuario_atual, Template)
end

When(/^eu tento acessar a página de templates$/) do
  if TemplatePolicy.new(usuario_atual, Template).index?
    visit templates_path
  else
    estado[:templates_visiveis] = Template.none
    estado[:mensagens] << "Você não tem permissão para visualizar templates."
  end
end

When(/^eu acesso a página de edição do template "([^"]+)"$/) do |titulo|
  template = Template.find_by!(titulo: titulo)
  estado[:template_atual] = template
  preparar_formulario_de_template
  estado[:template_form][:titulo] = template.titulo
  estado[:template_form][:descricao] = template.descricao

  template.questoes_ordenadas.each do |utilizacao|
    estado[:template_form][:questoes] << {
      id: utilizacao.questao_id,
      enunciado: utilizacao.questao.enunciado,
      tipo: utilizacao.questao.tipo,
      opcoes: utilizacao.questao.opcoes.ordenadas.pluck(:texto)
    }
  end

  if TemplatePolicy.new(usuario_atual, template).edit?
    visit edit_template_path(template)
  else
    estado[:mensagens] << "não tenho permissão para editar templates"
  end
end

When(/^eu tento acessar a página de edição do template "([^"]+)"$/) do |titulo|
  template = Template.find_by!(titulo: titulo)

  if TemplatePolicy.new(usuario_atual, template).edit?
    visit edit_template_path(template)
  else
    estado[:mensagens] << "não tenho permissão para editar templates"
  end
end

When(/^preencho o título do template com "([^"]+)"$/) do |titulo|
  estado[:template_form][:titulo] = titulo
end

When(/^deixo o título do template em branco$/) do
  estado[:template_form][:titulo] = nil
end

When(/^preencho a descrição do template com "([^"]+)"$/) do |descricao|
  estado[:template_form][:descricao] = descricao
end

When(/^adiciono uma questão de texto com enunciado "([^"]+)"$/) do |enunciado|
  estado[:template_form][:questoes] << {
    enunciado: enunciado,
    tipo: :discursiva,
    opcoes: []
  }
end

When(/^adiciono uma questão de múltipla escolha com enunciado "([^"]+)"$/) do |enunciado|
  estado[:template_form][:questoes] << {
    enunciado: enunciado,
    tipo: :objetiva,
    opcoes: []
  }
end

When(
  /^adiciono as opções "([^"]+)", "([^"]+)", "([^"]+)" e "([^"]+)" para a questão de múltipla escolha$/
) do |primeira, segunda, terceira, quarta|
  questao = estado[:template_form][:questoes].reverse.find do |item|
    item[:tipo] == :objetiva
  end

  questao.fetch(:opcoes).concat([ primeira, segunda, terceira, quarta ])
end

When(/^altero o título do template para "([^"]+)"$/) do |titulo|
  estado[:template_form][:titulo] = titulo
end

When(/^altero a descrição do template para "([^"]+)"$/) do |descricao|
  estado[:template_form][:descricao] = descricao
end

When(/^altero a questão "([^"]+)" para "([^"]+)"$/) do |antiga, nova|
  questao = estado[:template_form][:questoes].find do |item|
    item[:enunciado] == antiga
  end

  questao[:enunciado] = nova
end

When(/^confirmo a criação do template$/) do
  template = Template.new(template_params_do_formulario.fetch(:template))
  template.adm = adm_atual
  estado[:template_tentado] = template

  unless TemplatePolicy.new(usuario_atual, template).create?
    estado[:mensagens] << "não tenho permissão para criar templates"
    next
  end

  if template.save
    estado[:template_criado] = template
    estado[:mensagens] << "o template foi criado com sucesso"
    visit template_path(template)
  else
    estado[:mensagens] << mensagem_de_erro_do_template(template)
  end
end

When(/^confirmo a atualização do template$/) do
  template = estado.fetch(:template_atual)

  unless TemplatePolicy.new(usuario_atual, template).update?
    estado[:mensagens] << "não tenho permissão para editar templates"
    next
  end

  attributes = {
    titulo: estado[:template_form][:titulo],
    descricao: estado[:template_form][:descricao]
  }

  if template.update(attributes)
    estado[:mensagens] << "o template foi atualizado com sucesso"
    visit template_path(template)
  else
    estado[:mensagens] << mensagem_de_erro_do_template(template)
  end
end

When(/^solicito a exclusão do template "([^"]+)"$/) do |titulo|
  estado[:template_atual] = Template.find_by!(titulo: titulo)
end

When(/^eu tento excluir o template "([^"]+)"$/) do |titulo|
  estado[:template_atual] = Template.find_by!(titulo: titulo)
  template = estado[:template_atual]

  unless TemplatePolicy.new(usuario_atual, template).destroy?
    estado[:mensagens] << "não tenho permissão para deletar templates"
    next
  end

  page.driver.submit(:delete, template_path(template), {})
end

When(/^confirmo a exclusão do template$/) do
  template = estado.fetch(:template_atual)

  unless TemplatePolicy.new(usuario_atual, template).destroy?
    estado[:mensagens] << "não tenho permissão para deletar templates"
    next
  end

  within(%([data-template-id="#{template.id}"])) do
    find(%(button[aria-label="Excluir template #{template.titulo}"])).click
  end

  expect(page).to have_current_path(templates_path)
  expect(page).to have_content("Template excluído com sucesso.")
  estado[:mensagens] << "o template foi removido com sucesso"
end

Then(/^devo ver a mensagem "([^"]+)" na seção "([^"]+)"$/) do |mensagem, secao|
  seletor = {
    "Meus Templates" => "#meus-templates"
  }.fetch(secao)

  within(seletor) do
    expect(page).to have_content(mensagem)
  end
end

Then(/^devo ver a mensagem "Você não tem permissão para visualizar templates\."$/) do
  expect(estado[:mensagens]).to include("Você não tem permissão para visualizar templates.")
end

Then(
  /^devo ver uma mensagem informando que (o template .+|não tenho permissão para (?:criar|editar|deletar) templates|o título do template é obrigatório)$/
) do |mensagem|
  mensagem = mensagem.delete_suffix(".")

  expect(estado[:mensagens]).to include(mensagem)
end

Then(/^devo ver o template "([^"]+)"$/) do |titulo|
  expect(page).to have_content(titulo)
end

Then(/^devo ver o template "([^"]+)" na lista de templates$/) do |titulo|
  visit templates_path

  expect(page).to have_content(titulo)
end

Then(/^não devo ver o template "([^"]+)" na lista de templates$/) do |titulo|
  visit templates_path

  expect(page).not_to have_content(titulo)
end

Then(/^não devo ver o formulário de criação de template$/) do
  expect(estado[:formulario_visivel]).to be(false)
end

Then(/^devo ver a ação de excluir o template "([^"]+)"$/) do |titulo|
  template = Template.find_by!(titulo: titulo)

  within(%([data-template-id="#{template.id}"])) do
    expect(page).to have_button("Excluir template #{titulo}")
  end
end

Then(/^não devo ver a ação de excluir o template "([^"]+)"$/) do |titulo|
  template = Template.find_by!(titulo: titulo)

  within(%([data-template-id="#{template.id}"])) do
    expect(page).to have_no_button("Excluir template #{titulo}")
  end
end

Then(
  /^o formulário criado anteriormente deve continuar contendo a questão "([^"]+)"$/
) do |enunciado|
  formulario = estado.fetch(:formulario_anterior).reload

  expect(formulario.questoes.where(enunciado: enunciado)).to exist
end

Then(
  /^o formulário criado anteriormente não deve conter a questão "([^"]+)"$/
) do |enunciado|
  formulario = estado.fetch(:formulario_anterior).reload

  expect(formulario.questoes.where(enunciado: enunciado)).not_to exist
end
