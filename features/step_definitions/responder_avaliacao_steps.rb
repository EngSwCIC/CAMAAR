# frozen_string_literal: true

def criar_contexto_formulario_com_questoes(nome_turma)
  usuario = usuario_atual || estado[:usuario_participante] || usuario_participante
  definir_usuario_atual(usuario)

  depto = Departamento.find_or_create_by!(nome: "Departamento Geral")
  materia = Materia.find_or_create_by!(nome: nome_turma, departamento: depto) do |m|
    m.codigo = "COD#{rand(1000..9999)}"
  end

  @turma = Turma.find_or_create_by!(materia: materia, ano: 2026, semestre: :primeiro) do |t|
    t.numero = rand(1..100)
  end

  adm = Usuario.create!(
    nome: "Administrador",
    email: "administrador#{rand(10000)}@t.com",
    matricula: "ADM#{rand(10000..99999)}",
    senha: "password123",
    status: :ativo
  )
  perf_adm = PerfilAdm.create!(usuario: adm, departamento: depto)

  @questao_discursiva = Questao.create!(
    enunciado: "Como você avalia a turma?",
    tipo: :discursiva
  )

  @questao_objetiva = Questao.create!(
    enunciado: "Qual nota você dá?",
    tipo: :objetiva,
    opcoes_attributes: [
      { numero: 1, texto: "Ótimo" },
      { numero: 2, texto: "Ruim" }
    ]
  )

  template = Template.create!(
    adm: perf_adm,
    titulo: "Template #{rand(1000)}",
    utilizacoes_questoes_attributes: [
      { questao_id: @questao_discursiva.id, numero: 1 },
      { questao_id: @questao_objetiva.id,   numero: 2 }
    ]
  )

  @questao_discursiva.reload
  @questao_objetiva.reload

  @formulario = Formulario.create!(
    adm: perf_adm,
    turma: @turma,
    publico_alvo: :discentes,
    template: template
  )
  copiar_questoes_do_template_para_formulario(@formulario, template)
  @questao_discursiva = @formulario.questoes.find_by!(enunciado: @questao_discursiva.enunciado)
  @questao_objetiva = @formulario.questoes.find_by!(enunciado: @questao_objetiva.enunciado)

  PerfilDiscente.find_or_create_by!(usuario: usuario)
  ParticipacaoTurma.find_or_create_by!(
    usuario: usuario,
    turma: @turma,
    tipo_participacao: :discente
  )

  participacao = ParticipacaoTurma.find_by!(usuario: usuario, turma: @turma)
  @avaliacao = Avaliacao.create!(formulario: @formulario, participacao_turma: participacao)
end

Given('que estou na página de resposta do formulário da turma {string}') do |nome_turma|
  criar_contexto_formulario_com_questoes(nome_turma)
  visit responder_avaliacao_path(@avaliacao)
end

Given('que já respondi o formulário da turma {string} anteriormente') do |nome_turma|
  criar_contexto_formulario_com_questoes(nome_turma)
  @avaliacao.marcar_como_respondida!
end

When('eu preencho todas as questões obrigatórias') do
  fill_in "respostas[#{@questao_discursiva.id}][texto]", with: "Achei a turma muito boa."

  primeira_opcao = @questao_objetiva.opcoes.ordenadas.first
  within "#questao-#{@questao_objetiva.id}" do
    choose primeira_opcao.texto
  end
end

When('eu deixo uma questão obrigatória em branco') do
  fill_in "respostas[#{@questao_discursiva.id}][texto]", with: "Resposta parcial."
end

When('confirmo o envio da avaliação') do
  click_button "Confirmar envio"
end

When('eu tento acessar a página de resposta do formulário da turma {string}') do |_nome_turma|
  visit responder_avaliacao_path(@avaliacao)
end

Then('devo ver uma mensagem informando que a avaliação foi registrada com sucesso') do
  expect(page).to have_content("Avaliação registrada com sucesso.")
end

Then('o formulário da turma {string} não deve mais aparecer na lista de pendentes') do |nome_turma|
  expect(page).not_to have_content(nome_turma)
end

Then('devo ver uma mensagem informando que todas as questões obrigatórias devem ser preenchidas') do
  expect(page).to have_content("Todas as questões obrigatórias devem ser preenchidas.")
end

Then('a avaliação não deve ser registrada') do
  @avaliacao.reload
  expect(@avaliacao.respondida?).to be false
end

Then('devo ver uma mensagem informando que esta avaliação já foi respondida') do
  expect(page).to have_content("Esta avaliação já foi respondida.")
end
