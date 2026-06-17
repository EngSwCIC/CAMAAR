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

# Admin
admin = Administrador.find_or_initialize_by(email: "admin@teste.com")
admin.update!(
  nome: "Admin Teste",
  matricula: "240000003",
  senha: "teste123",
  senha_confirmation: "teste123",
  departamento: dept_cic
) unless admin.persisted?

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

# ==========================================
# VINCULANDO USUÁRIOS ÀS TURMAS
# ==========================================

# Professores nas turmas
docente_1.turmas << turma_ed_a unless docente_1.turmas.include?(turma_ed_a)
docente_1.turmas << turma_ed_b unless docente_1.turmas.include?(turma_ed_b)
docente_2.turmas << turma_isc_a unless docente_2.turmas.include?(turma_isc_a)

# Turma ED A: Alunos 1, 2 e 3
[alunos[0], alunos[1], alunos[2]].each do |aluno|
  aluno.turmas << turma_ed_a unless aluno.turmas.include?(turma_ed_a)
end

# Turma ED B: Alunos 3, 4 e 5
[alunos[2], alunos[3], alunos[4]].each do |aluno|
  aluno.turmas << turma_ed_b unless aluno.turmas.include?(turma_ed_b)
end

# Turma ISC A: Alunos 1, 4 e 5
[alunos[0], alunos[4], alunos[3]].each do |aluno|
  aluno.turmas << turma_isc_a unless aluno.turmas.include?(turma_isc_a)
end

# ==========================================
# TEMPLATES E ESTRUTURA BASE DE FORMULÁRIOS
# ==========================================
template = Template.find_or_initialize_by(nome: "Avaliação de Disciplina Padrão")

if template.new_record?
  elemento_nota = template.elementos.build(enunciado: "Avalie a didática do professor", ordem: 1)
  (1..5).each do |valor|
    elemento_nota.campos.build(enunciado: valor.to_s, ordem: valor, tipo_elemento: "Múltipla Escolha")
  end

  elemento_opcoes = template.elementos.build(enunciado: "Como você avalia a dificuldade das listas de exercícios?", ordem: 2)
  ["Muito Fácil", "Adequada", "Muito Difícil"].each_with_index do |opcao, index|
    elemento_opcoes.campos.build(enunciado: opcao, ordem: index + 1, tipo_elemento: "Múltipla Escolha")
  end

  elemento_texto = template.elementos.build(enunciado: "Deixe um comentário ou sugestão sobre a disciplina", ordem: 3)
  elemento_texto.campos.build(enunciado: nil, ordem: 1, tipo_elemento: "Texto")

  template.save!
end

# ==========================================
# FORMULÁRIOS DAS TURMAS E RESPOSTAS
# ==========================================

def configurar_formulario_e_respostas(turma, template_base, dados_alunos)
  formulario = Formulario.find_or_create_by!(turma: turma)

  template_base.elementos.order(:ordem).each do |elemento_base|
    ef = ElementoForm.find_or_create_by!(enunciado: elemento_base.enunciado, formulario: formulario) do |e|
      e.ordem = elemento_base.ordem
    end

    elemento_base.campos.order(:ordem).each do |campo_base|
      CampoForm.find_or_create_by!(enunciado: campo_base.enunciado, elemento_form: ef) do |c|
        c.ordem = campo_base.ordem
      end
    end
  end

  dados_alunos.each do |dado|
    aluno = dado[:aluno]
    respostas = dado[:respostas]

    resposta_form = RespostaForm.find_or_create_by!(formulario: formulario, usuario: aluno) do |rf|
      rf.data_submissao = Date.today
    end

    formulario.elemento_forms.order(:ordem).each_with_index do |ef, index|
      texto_respondido = respostas[index].to_s
      cf = ef.campo_forms.find_by(enunciado: texto_respondido) || ef.campo_forms.first

      RespostaElem.find_or_create_by!(resposta_form: resposta_form, elemento_form: ef) do |re|
        re.texto_resposta = texto_respondido
        re.campo_form = cf
      end
    end
  end
end

configurar_formulario_e_respostas(
  turma_ed_a,
  template,
  [
    { aluno: alunos[0], respostas: ["5", "Adequada", "Ótima didática, recomendo!"] },
    { aluno: alunos[1], respostas: ["4", "Muito Difícil", "As listas poderiam ter mais exemplos práticos."] },
    { aluno: alunos[2], respostas: ["5", "Adequada", "Sem reclamações, matéria excelente."] }
  ]
)

configurar_formulario_e_respostas(
  turma_ed_b,
  template,
  [
    { aluno: alunos[2], respostas: ["3", "Muito Difícil", "O ritmo das aulas está muito acelerado."] },
    { aluno: alunos[3], respostas: ["4", "Adequada", "Gostei da metodologia."] },
    { aluno: alunos[4], respostas: ["2", "Muito Difícil", "Preciso de mais monitoria para acompanhar."] }
  ]
)

configurar_formulario_e_respostas(
  turma_isc_a,
  template,
  [
    { aluno: alunos[0], respostas: ["5", "Muito Fácil", "Projetos práticos são muito divertidos!"] },
    { aluno: alunos[4], respostas: ["5", "Adequada", "O professor tira todas as dúvidas e os projetos ajudam muito."] },
    { aluno: alunos[3], respostas: ["4", "Adequada", "Gostaria de mais exercícios de fixação antes das provas."] }
  ]
)

puts "Seeds finalizados com sucesso! Campos padronizados como Texto e Múltipla Escolha."
