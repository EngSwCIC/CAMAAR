# encoding: UTF-8

require 'csv'

Dado("que estou na página de Resultados") do
  @departamento = Departamento.create!(
    codigo: "DEP01",
    nome:   "Departamento de Computação"
  )

  @admin = Administrador.create!(
    matricula:    "ADM001",
    nome:         "Admin Teste",
    email:        "admin@teste.com",
    departamento: @departamento
  )

  # Reutiliza o step de login já existente nos steps de autenticação
  step 'que meu usuário está cadastrado com o email "admin@teste.com" e senha "senha123"'
  step 'eu tento realizar o login com o email "admin@teste.com" e a senha "senha123"'

  visit admin_resultados_path(@admin)
end

Dado("vejo os formulários enviados para todas as turmas do meu departamento") do
  expect(page).to have_current_path(admin_resultados_path(@admin))
end

Dado("existe a {string} de {string} que possui um formulário associado a ela") do |nome_turma, nome_disciplina|
  @disciplina = Disciplina.create!(
    codigo:      "ED001",
    nome:        nome_disciplina,
    departamento: @departamento
  )

  @turma = Turma.create!(
    numero_da_turma: nome_turma,
    semestre:        "2024.1",
    horario:         "SEG 08:00-10:00",
    disciplina:      @disciplina
  )

  @formulario = Formulario.create!(turma: @turma)

  @elemento1 = ElementoForm.create!(
    ordem:       1,
    enunciado:   "Como você avalia o professor?",
    formulario:  @formulario
  )

  @elemento2 = ElementoForm.create!(
    ordem:       2,
    enunciado:   "Como você avalia a disciplina?",
    formulario:  @formulario
  )
end

Dado("este formulário já possui respostas enviadas pelos alunos") do
  @curso_aluno = Curso.create!(
    codigo:       "CC01",
    nome:         "Ciência da Computação",
    departamento: @departamento
  )

  @aluno = Discente.create!(
    matricula:    "ALU001",
    nome:         "Aluno Teste",
    email:        "aluno@teste.com",
    curso:        @curso_aluno,
    departamento: @departamento
  )

  @resposta = RespostaForm.create!(
    formulario:     @formulario,
    usuario:        @aluno,
    data_submissao: Date.today
  )

  @template = Template.new(nome: "Template Padrão", administrador: @admin)
  elemento_base = @template.elementos.build(ordem: 1, enunciado: "Avaliação")
  elemento_base.campos.build(ordem: 1, enunciado: "Muito bom",  tipo_elemento: "Múltipla Escolha")
  elemento_base.campos.build(ordem: 2, enunciado: "Excelente",  tipo_elemento: "Múltipla Escolha")
  @template.save!

  [ @elemento1, @elemento2 ].each do |ef|
    elemento_base.campos.each do |campo_base|
      CampoForm.find_or_create_by!(enunciado: campo_base.enunciado, elemento_form: ef) do |cf|
        cf.ordem = campo_base.ordem
      end
    end
  end

  {
    @elemento1 => "Muito bom",
    @elemento2 => "Excelente"
  }.each do |ef, texto|
    cf = ef.campo_forms.find_by!(enunciado: texto)

    RespostaElem.create!(
      texto_resposta: texto,
      resposta_form:  @resposta,
      elemento_form:  ef,
      campo_form:     cf
    )
  end

  visit admin_resultados_path(@admin)
end


# Happy Path

Quando("eu sigo {string}") do |link|
  formulario_alvo = defined?(@formulario_vazio) ? @formulario_vazio : @formulario
  find(:link, link, href: /#{formulario_alvo.id}/).click
end

Então("o download do arquivo {string} é iniciado") do |_nome_ignorado|
  num_turma    = @formulario.turma.numero_da_turma.parameterize(separator: '_')
  nome_materia = @formulario.turma.disciplina.nome.parameterize(separator: '_')
  nome_esperado = "formulario_#{@formulario.id}_turma_#{num_turma}_#{nome_materia}"

  content_disposition = page.response_headers["Content-Disposition"]

  expect(content_disposition).to be_present,
    "Esperava um header Content-Disposition indicando download, mas não havia nenhum."

  expect(content_disposition).to include("attachment"),
    "Esperava 'attachment' no Content-Disposition, mas foi: #{content_disposition}"

  expect(content_disposition).to include(nome_esperado),
    "Esperava '#{nome_esperado}' no nome do arquivo, " \
    "mas o header foi: #{content_disposition}"
end

Então("o arquivo deve conter as colunas Usuário da Resposta, Data de Submissão e elementos do formulário") do
  csv_content = CSV.parse(page.body)
  cabecalho   = csv_content.first

  expect(cabecalho).to include("Usuário da Resposta"),
    "Esperava a coluna 'Usuário da Resposta' no cabeçalho, mas foi: #{cabecalho.inspect}"

  expect(cabecalho).to include("Data de Submissão"),
    "Esperava a coluna 'Data de Submissão' no cabeçalho, mas foi: #{cabecalho.inspect}"

  ElementoForm.where(formulario_id: @formulario.id).order(:ordem).each do |elem|
    expect(cabecalho).to include(elem.enunciado),
      "Esperava a coluna '#{elem.enunciado}' no cabeçalho, mas foi: #{cabecalho.inspect}"
  end
end

Então("o arquivo deve conter como linhas as respostas de cada usuário") do
  csv_content = CSV.parse(page.body)

  linhas_de_dados = csv_content[1..]

  expect(linhas_de_dados).not_to be_empty,
    "Esperava pelo menos uma linha de dados no CSV, mas o arquivo só possui o cabeçalho."

  nomes_nas_linhas = linhas_de_dados.map(&:first)
  expect(nomes_nas_linhas).to include(@aluno.nome),
    "Esperava encontrar '#{@aluno.nome}' nas linhas de dados, mas encontrei: #{nomes_nas_linhas.inspect}"

  RespostaElem.where(resposta_form_id: @resposta.id).each do |re|
    conteudo_csv = linhas_de_dados.flatten
    expect(conteudo_csv).to include(re.texto_resposta),
      "Esperava encontrar a resposta '#{re.texto_resposta}' no CSV."
  end
end

# Sad Path

Dado("que a {string} possui outro formulário") do |nome_turma|
  @turma_sad = Turma.find_by(numero_da_turma: nome_turma) || @turma

  @formulario_vazio = Formulario.create!(turma: @turma_sad)

  ElementoForm.create!(
    ordem:      1,
    enunciado:  "Pergunta sem respostas",
    formulario: @formulario_vazio
  )
end

Dado("este formulário não recebeu nenhuma resposta até o momento") do
  expect(
    RespostaForm.where(formulario_id: @formulario_vazio.id).count
  ).to eq(0), "Esperava 0 respostas para o formulário vazio, mas havia algumas."

  visit admin_resultados_path(@admin)
end

Então("vejo a mensagem de erro {string}") do |mensagem_esperada|
  expect(page).to have_content(mensagem_esperada),
    "Esperava ver '#{mensagem_esperada}' na página, mas não encontrei."
end

Então("nenhum download de arquivo é iniciado") do
  content_disposition = page.response_headers["Content-Disposition"]

  expect(content_disposition).to be_nil.or(
    satisfy { |cd| !cd.to_s.include?("attachment") }
  ), "Não esperava um header de download 'attachment', mas encontrei: #{content_disposition}"
end
