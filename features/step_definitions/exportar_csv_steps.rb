# frozen_string_literal: true

# == Descrição
# Método auxiliar para os testes que recupera ou define o usuário administrador no contexto atual da sessão ou estado do teste.
#
# == Argumentos
# * Nenhum.
#
# == Retorno
# * Retorna uma instância de +Usuario+ que possui privilégios de administrador.
#
# == Efeitos Colaterais
# * Nenhum. Apenas leitura de variáveis locais e de estado.
def administrador_csv
  usuario_atual || estado[:usuario_administrador] || usuario_administrador
end

# == Descrição
# Método auxiliar para os testes que recupera o departamento vinculado ao administrador logado no cenário.
#
# == Argumentos
# * Nenhum.
#
# == Retorno
# * Retorna a instância de +Departamento+ associada ao perfil do administrador.
#
# == Efeitos Colaterais
# * Nenhum. Executa apenas a navegação pelas associações do objeto em memória.
def departamento_csv
  administrador_csv.perfil_adm.departamento
end

# -------------------------------------------------------
# Cenário 1: Formulário com Respostas (@happy)
# -------------------------------------------------------

# == Descrição
# Prepara o banco de dados com toda a hierarquia necessária (matéria, turma, template e formulário)
# e simula um aluno que já respondeu a este formulário com uma questão discursiva.
Given('que existe um formulário com respostas para a turma {string}') do |nome_turma|
  materia = Materia.find_or_create_by!(nome: nome_turma, departamento: departamento_csv) { |m| m.codigo = "COD#{rand(1000)}" }
  @turma = Turma.find_or_create_by!(materia: materia, ano: 2026, semestre: :primeiro) { |t| t.numero = 1 }

  @questao = Questao.create!(enunciado: "Avalie o professor", tipo: :discursiva)

  template = Template.create!(
    adm: administrador_csv.perfil_adm,
    titulo: "Template Padrão",
    utilizacoes_questoes_attributes: [
      { questao_id: @questao.id, numero: 1 }
    ]
  )

  @formulario = Formulario.create!(
    adm: administrador_csv.perfil_adm,
    turma: @turma,
    publico_alvo: :discentes,
    template: template
  )
  copiar_questoes_do_template_para_formulario(@formulario, template)
  @questao = @formulario.questoes.find_by!(enunciado: @questao.enunciado)

  aluno = Usuario.create!(
    nome: "João Respondedor",
    email: "joao#{rand(1000)}@teste.com",
    matricula: "MAT#{rand(10000..99999)}",
    senha: "password123",
    status: :ativo
  )
  PerfilDiscente.create!(usuario: aluno)
  part = ParticipacaoTurma.create!(usuario: aluno, turma: @turma, tipo_participacao: :discente)

  avaliacao = Avaliacao.create!(formulario: @formulario, participacao_turma: part)
  avaliacao.marcar_como_respondida!


  resposta = Resposta.new(avaliacao: avaliacao, questao: @questao)
  resposta.build_texto(texto: "Ótima aula!")
  resposta.save!(validate: false)
end

# == Descrição
# Simula a navegação inicial do administrador para o painel de relatórios do departamento.
When('eu acesso a página de relatórios do meu departamento') do
end

# == Descrição
# Aciona a rota que faz o download do CSV para o formulário previamente criado.
When('solicito a exportação do formulário da turma {string}') do |_nome_turma|
  visit exportar_csv_formulario_path(@formulario)
end

# == Descrição
# Inspeciona os cabeçalhos da resposta HTTP para garantir que o navegador recebeu a instrução de baixar um anexo do tipo CSV.
Then('o download do arquivo CSV deve ser iniciado') do
  expect(page.response_headers["Content-Type"]).to include "text/csv"
  expect(page.response_headers["Content-Disposition"]).to include "attachment"
end

# == Descrição
# Faz a leitura do corpo do arquivo baixado e verifica se o nome do aluno, a pergunta e a resposta constam no texto.
Then('o CSV deve conter os dados esperados das avaliações') do
  expect(page.body).to include("João Respondedor")
  expect(page.body).to include("Avalie o professor")
  expect(page.body).to include("Ótima aula!")
end

# -------------------------------------------------------
# Cenário 2: Formulário sem Respostas (@happy)
# -------------------------------------------------------

# == Descrição
# Configura o banco de dados com um formulário ativo, porém sem simular nenhuma submissão de respostas por alunos.
Given('que existe um formulário sem respostas para a turma {string} do meu departamento') do |nome_turma|
  materia = Materia.find_or_create_by!(nome: nome_turma, departamento: departamento_csv) { |m| m.codigo = "COD#{rand(1000)}" }
  @turma = Turma.find_or_create_by!(materia: materia, ano: 2026, semestre: :primeiro) { |t| t.numero = 1 }

  @questao = Questao.create!(enunciado: "Avalie a infraestrutura", tipo: :discursiva)

  template = Template.create!(
    adm: administrador_csv.perfil_adm,
    titulo: "Template Vazio",
    utilizacoes_questoes_attributes: [
      { questao_id: @questao.id, numero: 1 }
    ]
  )

  @formulario_vazio = Formulario.create!(
    adm: administrador_csv.perfil_adm,
    turma: @turma,
    publico_alvo: :discentes,
    template: template
  )
  copiar_questoes_do_template_para_formulario(@formulario_vazio, template)
  @questao = @formulario_vazio.questoes.find_by!(enunciado: @questao.enunciado)
end

# == Descrição
# Acessa o endpoint de geração de relatório para o formulário vazio configurado no cenário.
When('eu solicito a exportação do formulário da turma {string}') do |_nome_turma|
  visit exportar_csv_formulario_path(@formulario_vazio)
end

# == Descrição
# Garante que o arquivo gerado contenha estritamente uma única linha correspondente ao cabeçalho das colunas.
Then('o arquivo CSV deve conter apenas a linha de cabeçalho') do
  linhas = page.body.split("\n")
  expect(linhas.size).to eq(1)
  expect(linhas.first).to include("Aluno;Matrícula;Avalie a infraestrutura")
end

# -------------------------------------------------------
# Cenário 3: Tentativa de Acesso por Não-Administrador (@sad)
# -------------------------------------------------------

# == Descrição
# Cria o contexto de um formulário válido e simula a requisição direta na rota de exportação por um usuário sem privilégios.
When('eu tento acessar a rota de exportação de resultados em CSV') do
  depto = Departamento.find_or_create_by!(nome: "Departamento Teste")
  materia = Materia.find_or_create_by!(nome: "Matéria", departamento: depto) { |m| m.codigo = "MAT001" }
  turma = Turma.find_or_create_by!(materia: materia, ano: 2026, semestre: :primeiro) { |t| t.numero = 1 }

  admin_dono = Usuario.find_or_create_by!(email: "dono#{rand(1000)}@t.com") do |u|
    u.nome = "Dono"
    u.matricula = "DONO#{rand(10000..99999)}"
    u.senha = "password123"
    u.status = :ativo
  end
  perf = PerfilAdm.create!(usuario: admin_dono, departamento: depto)

  questao = Questao.create!(enunciado: "Questao Sad", tipo: :discursiva)
  template = Template.create!(
    adm: perf,
    titulo: "Template Sad",
    utilizacoes_questoes_attributes: [
      { questao_id: questao.id, numero: 1 }
    ]
  )

  form = Formulario.create!(adm: perf, turma: turma, publico_alvo: :discentes, template: template)
  copiar_questoes_do_template_para_formulario(form, template)

  visit exportar_csv_formulario_path(form)
end

# == Descrição
# Confirma se o Controller barrou o acesso e exibiu o alerta correto na tela, cumprindo as exigências de segurança.
Then('devo ver uma mensagem informando que apenas administradores possuem acesso a este recurso') do
  expect(page).to have_content("Apenas administradores possuem acesso a este recurso")
end
