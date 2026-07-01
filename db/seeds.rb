# This file should ensure the existence of records required to run the application in every environment.
# The code here should be idempotent so that it can be executed at any point in every environment.

# Departamentos
dept_cic = Departamento.find_or_create_by!(codigo: "CIC") do |d|
  d.nome = "Ciência da Computação"
end

dept_mat = Departamento.find_or_create_by!(codigo: "MAT") do |d|
  d.nome = "Matemática"
end

# Cursos
curso_cc = Curso.find_or_create_by!(codigo: "CC") do |c|
  c.nome = "Bacharelado em Ciência da Computação"
  c.departamento = dept_cic
end

# Disciplinas
disc_ed = Disciplina.find_or_create_by!(codigo: "CIC0001") do |d|
  d.nome = "Estrutura de Dados"
  d.departamento = dept_cic
end

disc_isc = Disciplina.find_or_create_by!(codigo: "CIC0002") do |d|
  d.nome = "Introdução aos Sistemas de Computação"
  d.departamento = dept_cic
end

disc_apc = Disciplina.find_or_create_by!(codigo: "CIC0003") do |d|
  d.nome = "Algoritmos e Programação de Computadores"
  d.departamento = dept_cic
end

# Turmas
turma_ed_a = Turma.find_or_create_by!(numero_da_turma: "A", semestre: "2026.1", disciplina: disc_ed) do |t|
  t.horario = "35T23"
end

turma_ed_b = Turma.find_or_create_by!(numero_da_turma: "B", semestre: "2026.1", disciplina: disc_ed) do |t|
  t.horario = "35M23"
end

# Introdução aos Sistemas de Computação - Turma A
turma_isc_a = Turma.find_or_create_by!(numero_da_turma: "A", semestre: "2026.1", disciplina: disc_isc) do |t|
  t.horario = "24T23"
end

# Usuários (Docente, Discente, Admin)
# A migration AjustaNulosParaSti permite que curso e departamento sejam nulos,
# mas vamos associá-los aos nossos testes para dados mais ricos.

# Docentes
docente_1 = Docente.find_or_initialize_by(email: "docente1@teste.com")
docente_1.nome ||= "Professor de ED"
docente_1.matricula ||= "241000001"
docente_1.senha = "teste123"
docente_1.senha_confirmation = "teste123"
docente_1.departamento = dept_cic
docente_1.formacao = "doutorado"
docente_1.save!

docente_2 = Docente.find_or_initialize_by(email: "docente2@teste.com")
docente_2.nome ||= "Professor de ISC"
docente_2.matricula ||= "241000011"
docente_2.senha = "teste123"
docente_2.senha_confirmation = "teste123"
docente_2.departamento = dept_cic
docente_2.formacao = "doutorado"
docente_2.save!

docente_3 = Docente.find_or_initialize_by(email: "docente3@teste.com")
docente_3.nome ||= "Zequinha Banana"
docente_3.matricula ||= "241000069"
docente_3.senha = "teste123"
docente_3.senha_confirmation = "teste123"
docente_3.departamento = dept_cic
docente_3.formacao = "doutorado"
docente_3.save!

# Admin
admin = Administrador.find_or_initialize_by(email: "admin@teste.com")
admin.nome ||= "Admin Teste"
admin.matricula ||= "240000003"
admin.senha = "teste123"
admin.senha_confirmation = "teste123"
admin.departamento = dept_cic
admin.save!

# Discentes (Lista de novos alunos)
alunos_dados = [
  { email: "discente1@teste.com", nome: "Ana Silva", matricula: "241000002" },
  { email: "discente2@teste.com", nome: "Bruno Santos", matricula: "241000004" },
  { email: "discente3@teste.com", nome: "Carlos Oliveira", matricula: "241000005" },
  { email: "discente4@teste.com", nome: "Diana Costa", matricula: "241000006" },
  { email: "discente5@teste.com", nome: "Eduardo Ribeiro", matricula: "241000007" }
]

alunos = alunos_dados.map do |dados|
  aluno = Discente.find_or_initialize_by(email: dados[:email])
  aluno.nome ||= dados[:nome]
  aluno.matricula ||= dados[:matricula]
  aluno.senha = "teste123"
  aluno.senha_confirmation = "teste123"
  aluno.curso = curso_cc
  aluno.save!
  aluno
end
docente = Docente.find_or_initialize_by(email: "gusfring.a@gmail.com")
docente.nome ||= "GUS"
docente.matricula ||= "241000067"
docente.senha = "teste123"
docente.senha_confirmation = "teste123"
docente.departamento = dept_cic
docente.formacao = "doutorado"
docente.save!

# ==========================================
# VINCULANDO USUÁRIOS ÀS TURMAS
# ==========================================

# Professores nas turmas
docente_1.turmas << turma_ed_a unless docente_1.turmas.include?(turma_ed_a)
docente_1.turmas << turma_ed_b unless docente_1.turmas.include?(turma_ed_b)
docente_2.turmas << turma_isc_a unless docente_2.turmas.include?(turma_isc_a)
docente_3.turmas << turma_ed_a unless docente_3.turmas.include?(turma_ed_a)

# Distribuindo alunos nas turmas para gerar variação de dados
# Turma ED A: Alunos 1, 2 e 3
[ alunos[0], alunos[1], alunos[2] ].each do |aluno|
  aluno.turmas << turma_ed_a unless aluno.turmas.include?(turma_ed_a)
end

# Turma ED B: Alunos 3, 4 e 5
[ alunos[2], alunos[3], alunos[4] ].each do |aluno|
  aluno.turmas << turma_ed_b unless aluno.turmas.include?(turma_ed_b)
end

# Turma ISC A: Alunos 1, 4 e 5
[ alunos[0], alunos[4], alunos[3] ].each do |aluno|
  aluno.turmas << turma_isc_a unless aluno.turmas.include?(turma_isc_a)
end

# ==========================================
# TEMPLATES E ESTRUTURA BASE DE FORMULÁRIOS
# ==========================================
# Usamos find_or_initialize_by para evitar o salvamento imediato e não quebrar a validação
template = Template.find_or_initialize_by(nome: "Avaliação de Disciplina Padrão")

if template.new_record?
  template.administrador = admin

  # ---------------------------------------------------------
  # Elemento 1: Múltipla Escolha (1 a 5)
  # ---------------------------------------------------------
  elemento_nota = template.elementos.build(enunciado: "Avalie a didática do professor", ordem: 1)

  (1..5).each do |valor|
    elemento_nota.campos.build(enunciado: valor.to_s, ordem: valor, tipo_elemento: "Múltipla Escolha")
  end

  # ---------------------------------------------------------
  # Elemento 2: Múltipla Escolha (Dificuldade)
  # ---------------------------------------------------------
  elemento_opcoes = template.elementos.build(enunciado: "Como você avalia a dificuldade das listas de exercícios?", ordem: 2)

  [ "Muito Fácil", "Adequada", "Muito Difícil" ].each_with_index do |opcao, index|
    elemento_opcoes.campos.build(enunciado: opcao, ordem: index + 1, tipo_elemento: "Múltipla Escolha")
  end

  # ---------------------------------------------------------
  # Elemento 3: Texto Livre
  # ---------------------------------------------------------
  elemento_texto = template.elementos.build(enunciado: "Deixe um comentário ou sugestão sobre a disciplina", ordem: 3)

  elemento_texto.campos.build(enunciado: nil, ordem: 1, tipo_elemento: "Texto")

  # Salva o bloco inteiro (Template + Elementos + Campos) de uma vez, satisfazendo a validação
  template.save!
end

# ==========================================
# FORMULÁRIOS DAS TURMAS E RESPOSTAS
# ==========================================

# Método auxiliar corrigido para clonar TODOS os campos e associar a resposta ao campo correto
def configurar_formulario_e_respostas(turma, template_base, dados_alunos)
  formulario = Formulario.find_or_create_by!(turma: turma)

  # 1. Clona todos os elementos e TODOS os seus respectivos campos para o formulário
  template_base.elementos.order(:ordem).each do |elemento_base|
    tipo_do_elemento = elemento_base.campos.first&.tipo_elemento || "Múltipla Escolha"

    ef = ElementoForm.find_or_create_by!(enunciado: elemento_base.enunciado, formulario: formulario) do |e|
      e.ordem = elemento_base.ordem
      e.tipo = tipo_do_elemento
    end

    ef.update!(tipo: tipo_do_elemento) if ef.tipo.nil?

    next if tipo_do_elemento == "Texto"

    # Cria os campos (opções) apenas para elementos de múltipla escolha
    elemento_base.campos.order(:ordem).each do |campo_base|
      CampoForm.find_or_create_by!(enunciado: campo_base.enunciado, elemento_form: ef) do |c|
        c.ordem = campo_base.ordem
      end
    end
  end

  # 2. Cria as respostas baseadas nos dados fornecidos
  dados_alunos.each do |dado|
    aluno = dado[:aluno]
    respostas = dado[:respostas] # Array com as strings das respostas na ordem das perguntas

    resposta_form = RespostaForm.find_or_create_by!(formulario: formulario, usuario: aluno) do |rf|
      rf.data_submissao = Date.today
    end

    # Itera sobre os elementos criados no formulário para salvar cada resposta
    formulario.elemento_forms.order(:ordem).each_with_index do |ef, index|
      texto_respondido = respostas[index].to_s

      # Busca o campo correspondente:
      # - Se for Múltipla Escolha, acha o campo que tem o enunciado igual à opção marcada (ex: "5" ou "Adequada")
      # - Se for Texto, pega o único campo disponível (onde o enunciado é nil)
      cf = ef.campo_forms.find_by(enunciado: texto_respondido) || ef.campo_forms.first

      RespostaElem.find_or_create_by!(resposta_form: resposta_form, elemento_form: ef) do |re|
        re.texto_resposta = texto_respondido
        re.campo_form = cf
      end
    end
  end
end

# Configurando dados para Estrutura de Dados - Turma A
configurar_formulario_e_respostas(
  turma_ed_a,
  template,
  [
    { aluno: alunos[0], respostas: [ "5", "Adequada", "Ótima didática, recomendo!" ] },
    { aluno: alunos[1], respostas: [ "4", "Muito Difícil", "As listas poderiam ter mais exemplos práticos." ] },
    { aluno: alunos[2], respostas: [ "5", "Adequada", "Sem reclamações, matéria excelente." ] }
  ]
)

# Configurando dados para Estrutura de Dados - Turma B
configurar_formulario_e_respostas(
  turma_ed_b,
  template,
  [
    { aluno: alunos[2], respostas: [ "3", "Muito Difícil", "O ritmo das aulas está muito acelerado." ] },
    { aluno: alunos[3], respostas: [ "4", "Adequada", "Gostei da metodologia." ] },
    { aluno: alunos[4], respostas: [ "2", "Muito Difícil", "Preciso de mais monitoria para acompanhar." ] }
  ]
)

# Configurando dados para Introdução aos Sistemas de Computação - Turma A
configurar_formulario_e_respostas(
  turma_isc_a,
  template,
  [
    { aluno: alunos[0], respostas: [ "5", "Muito Fácil", "Projetos práticos são muito divertidos!" ] },
    { aluno: alunos[4], respostas: [ "5", "Adequada", "O professor tira todas as dúvidas e os projetos ajudam muito." ] },
    { aluno: alunos[3], respostas: [ "4", "Adequada", "Gostaria de mais exercícios de fixação antes das provas." ] }
  ]
)

puts "Seeds finalizados com sucesso! Campos padronizados como Texto e Múltipla Escolha."
puts "Seeds finalizados com sucesso"
