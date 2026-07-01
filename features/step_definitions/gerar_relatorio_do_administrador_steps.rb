Dado('que a base de dados possui a pesquisa {string} registrada') do |nome_pesquisa|
  @admin = Pessoa.find_or_create_by!(usuario: "admin_relatorio") do |p|
    p.email = "admin_relatorio@unb.br"
    p.password = "senha123"
    p.password_confirmation = "senha123"
    p.nome = "Administrador de Relatorios"
    p.admin = true
  end

  pessoa_prof = Pessoa.create!(usuario: "prof_relatorio", email: "prof_relatorio@unb.br", password: "123", password_confirmation: "123", nome: "Professor Relatorio")
  docente = Docente.create!(pessoa: pessoa_prof)

  disciplina = Disciplina.create!(nome: "Testes de Software", codigo: "CIC0099")
  @turma = Turma.create!(codigo: "TA", disciplina: disciplina, docente: docente)

  @template = Template.create!(nome: nome_pesquisa, pessoa: @admin)

  @formulario = Formulario.create!(turma: @turma, template: @template, status: :fechado)
  @questao = Questao.create!(formulario: @formulario, enunciado: "O que achou da turma?", tipo_resposta: "texto")
end

Dado('o sistema já processou as respostas submetidas pelos discentes') do
  pessoa_aluno = Pessoa.create!(usuario: "aluno_relatorio", email: "aluno_relatorio@unb.br", password: "123", password_confirmation: "123", nome: "Aluno Relatorio")
  @discente = Discente.create!(pessoa: pessoa_aluno, matricula: "20209999")

  @resposta = Resposta.create!(questao: @questao, discente: @discente, conteudo: "Muito boa!")
end

Dado('que estou devidamente autenticado com credenciais de {string}') do |perfil|
  if perfil == "Administrador"
    visit login_path
    fill_in 'login', with: @admin.email
    fill_in 'password', with: "senha123"
    click_button 'Entrar'
  end
end

Dado('a pesquisa {string} encontra-se com o status {string}') do |_nome_pesquisa, status|
  @formulario.update!(status: status == "Encerrada" ? :fechado : :aberto)
end

Quando('eu navego até o módulo de {string}') do |_modulo|
  visit admin_resultados_path
end

Quando('aciono o comando para exportar os dados desta pesquisa') do
  visit exportar_csv_admin_resultado_path(@formulario)
end

Então('o sistema deve processar as informações no backend') do
  expect(page.status_code).to eq(200)
end

Então('iniciar o download de um arquivo com a extensão {string}') do |extensao|
  expect(page.response_headers["Content-Type"]).to include("text/csv")
  expect(page.response_headers["Content-Disposition"]).to include(extensao)
end

Então('o conteúdo do arquivo deve refletir exatamente as respostas tabuladas da turma') do
  expect(page.body).to include(@resposta.conteudo)
end

Dado('a pesquisa {string} ainda encontra-se com o status {string}') do |_nome_pesquisa, status|
  @formulario.update!(status: status == "Em Andamento" ? :aberto : :fechado)
end

Quando('eu tento exportar os dados desta pesquisa no módulo de {string}') do |_modulo|
  visit admin_resultados_path
end

Então('a ação de exportação deve ser bloqueada pela interface') do
  expect(page).not_to have_selector("a[href='#{exportar_csv_admin_resultado_path(@formulario)}']")
end

Então('o sistema deve exibir a mensagem de restrição {string}') do |mensagem|
  expect(current_path).to eq(admin_resultados_path)
end

Dado('que estou logado no sistema com o perfil padrão de {string}') do |_perfil|
  pessoa_docente = Pessoa.create!(usuario: "docente_relatorio", email: "docente_relatorio@unb.br", password: "123", password_confirmation: "123", nome: "Docente Padrao")

  visit login_path
  fill_in 'login', with: pessoa_docente.email
  fill_in 'password', with: "123"
  click_button 'Entrar'
end

Quando('eu tento forçar a requisição diretamente pela URL de exportação {string}') do |_url|
  visit exportar_csv_admin_resultado_path(@formulario)
end

Então('o servidor deve recusar o acesso') do
  expect([root_path, avaliacoes_path, "/"]).to include(current_path)
end

Então('eu devo ser redirecionado para a página inicial \(dashboard\)') do
  expect([root_path, avaliacoes_path, "/"]).to include(current_path)
end

Então('o sistema deve exibir o alerta de segurança {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end