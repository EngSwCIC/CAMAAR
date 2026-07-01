# frozen_string_literal: true

def utilizacoes_attributes_da_tabela(table)
  table.hashes.each_with_index.map do |linha, index|
    {
      numero: index + 1,
      questao_attributes: questao_attributes(
        enunciado: linha.fetch("enunciado"),
        tipo: linha.fetch("tipo")
      )
    }
  end
end

def template_por_titulo!(titulo)
  Template.find_by!(titulo: titulo, adm: adm_atual)
end

def questao_do_template!(template, enunciado)
  template
    .questoes
    .includes(:opcoes)
    .find_by!(enunciado: enunciado)
end

def utilizacao_da_questao!(template, enunciado)
  template
    .utilizacoes_questoes
    .includes(:questao)
    .find { |utilizacao| utilizacao.questao.enunciado == enunciado } ||
    raise(ActiveRecord::RecordNotFound, "Questão não encontrada: #{enunciado}")
end

def opcao_da_questao!(questao, texto)
  questao.opcoes.find_by!(texto: texto)
end

def submeter_criacao_de_template(titulo, utilizacoes_attributes)
  page.driver.submit(
    :post,
    templates_path,
    {
      template: {
        titulo: titulo,
        descricao: "Template criado em cenário de aceitação",
        utilizacoes_questoes_attributes: utilizacoes_attributes
      }
    }
  )
end

def submeter_atualizacao_de_template(template, utilizacoes_attributes)
  page.driver.submit(
    :patch,
    template_path(template),
    {
      template: {
        titulo: template.titulo,
        descricao: template.descricao,
        utilizacoes_questoes_attributes: utilizacoes_attributes
      }
    }
  )
end

def criar_template_com_questoes!(titulo, table)
  template = Template.create!(
    titulo: titulo,
    descricao: "Template criado em cenário de aceitação",
    adm: adm_atual,
    utilizacoes_questoes_attributes: utilizacoes_attributes_da_tabela(table)
  )

  estado[:template_atual] = template
end

When(/^envio o formulário do template "([^"]+)" com as questões:$/) do |titulo, table|
  submeter_criacao_de_template(titulo, utilizacoes_attributes_da_tabela(table))
end

Given(/^que existe o template "([^"]+)" com as questões:$/) do |titulo, table|
  criar_template_com_questoes!(titulo, table)
end

When(/^removo a questão "([^"]+)" do template "([^"]+)"$/) do |enunciado, titulo|
  template = template_por_titulo!(titulo)
  utilizacao = utilizacao_da_questao!(template, enunciado)

  submeter_atualizacao_de_template(
    template,
    {
      "0" => {
        id: utilizacao.id,
        _destroy: "1"
      }
    }
  )
end

When(/^reordeno as questões do template "([^"]+)" para:$/) do |titulo, table|
  template = template_por_titulo!(titulo)
  utilizacoes_por_enunciado = template
    .utilizacoes_questoes
    .includes(:questao)
    .index_by { |utilizacao| utilizacao.questao.enunciado }

  utilizacoes_attributes = table.hashes.each_with_index.to_h do |linha, index|
    utilizacao = utilizacoes_por_enunciado.fetch(linha.fetch("enunciado"))

    [
      index.to_s,
      {
        id: utilizacao.id,
        numero: index + 1
      }
    ]
  end

  submeter_atualizacao_de_template(template, utilizacoes_attributes)
end

Then(/^o template "([^"]+)" deve conter as questões na ordem:$/) do |titulo, table|
  template = template_por_titulo!(titulo)
  questoes = template
    .questoes_ordenadas
    .map { |utilizacao| utilizacao.questao.enunciado }

  expect(questoes).to eq(table.hashes.map { |linha| linha.fetch("enunciado") })
end

Given(
  /^que existe o template "([^"]+)" com a questão objetiva "([^"]+)" e as opções:$/
) do |titulo, enunciado, table|
  opcoes = table.hashes.map { |linha| linha.fetch("texto") }

  template = Template.create!(
    titulo: titulo,
    descricao: "Template criado em cenário de aceitação",
    adm: adm_atual,
    utilizacoes_questoes_attributes: [
      {
        numero: 1,
        questao_attributes: questao_attributes(
          enunciado: enunciado,
          tipo: :objetiva,
          opcoes: opcoes
        )
      }
    ]
  )

  estado[:template_atual] = template
end

When(
  /^adiciono as opções à questão "([^"]+)" do template "([^"]+)":$/
) do |enunciado, titulo, table|
  template = template_por_titulo!(titulo)
  utilizacao = utilizacao_da_questao!(template, enunciado)
  questao = utilizacao.questao
  proximo_numero = questao.opcoes.maximum(:numero).to_i + 1

  opcoes_attributes = table.hashes.each_with_index.to_h do |linha, index|
    [
      index.to_s,
      {
        numero: proximo_numero + index,
        texto: linha.fetch("texto")
      }
    ]
  end

  submeter_atualizacao_de_template(
    template,
    {
      "0" => {
        id: utilizacao.id,
        questao_attributes: {
          id: questao.id,
          enunciado: questao.enunciado,
          tipo: questao.tipo,
          opcoes_attributes: opcoes_attributes
        }
      }
    }
  )
end

When(
  /^removo a opção "([^"]+)" da questão "([^"]+)" do template "([^"]+)"$/
) do |texto, enunciado, titulo|
  template = template_por_titulo!(titulo)
  utilizacao = utilizacao_da_questao!(template, enunciado)
  questao = utilizacao.questao
  opcao = opcao_da_questao!(questao, texto)

  submeter_atualizacao_de_template(
    template,
    {
      "0" => {
        id: utilizacao.id,
        questao_attributes: {
          id: questao.id,
          opcoes_attributes: {
            "0" => {
              id: opcao.id,
              _destroy: "1"
            }
          }
        }
      }
    }
  )
end

When(
  /^reordeno as opções da questão "([^"]+)" do template "([^"]+)" para:$/
) do |enunciado, titulo, table|
  template = template_por_titulo!(titulo)
  utilizacao = utilizacao_da_questao!(template, enunciado)
  questao = utilizacao.questao
  opcoes_por_texto = questao.opcoes.index_by(&:texto)

  opcoes_attributes = table.hashes.each_with_index.to_h do |linha, index|
    opcao = opcoes_por_texto.fetch(linha.fetch("texto"))

    [
      index.to_s,
      {
        id: opcao.id,
        numero: index + 1
      }
    ]
  end

  submeter_atualizacao_de_template(
    template,
    {
      "0" => {
        id: utilizacao.id,
        questao_attributes: {
          id: questao.id,
          opcoes_attributes: opcoes_attributes
        }
      }
    }
  )
end

Then(
  /^a questão "([^"]+)" do template "([^"]+)" deve conter as opções na ordem:$/
) do |enunciado, titulo, table|
  template = template_por_titulo!(titulo)
  questao = questao_do_template!(template, enunciado)
  opcoes = questao.opcoes.ordenadas.pluck(:texto)

  expect(opcoes).to eq(table.hashes.map { |linha| linha.fetch("texto") })
end
