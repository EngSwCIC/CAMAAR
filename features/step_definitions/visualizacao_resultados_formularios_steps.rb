Dado('que o usuário está logado no sistema com o perfil de Administrador') do
  @admin = Pessoa.find_or_create_by!(usuario: "admin_resultados") do |p|
    p.email = "admin_resultados@unb.br"
    p.password = "senha123"
    p.password_confirmation = "senha123"
    p.nome = "Administrador de Resultados"
    p.admin = true
  end
  visit login_path
  fill_in 'login', with: @admin.email
  fill_in 'password', with: "senha123"
  click_button 'Entrar'
end

Dado('que existem formulários previamente cadastrados e com respostas coletadas no sistema') do
  pessoa_prof = Pessoa.create!(usuario: "prof_resultados", email: "prof_resultados@unb.br", password: "123", password_confirmation: "123", nome: "Professor Resultados")
  docente = Docente.create!(pessoa: pessoa_prof)
  disciplina = Disciplina.create!(nome: "Testes de Software", codigo: "CIC0200")
  @turma = Turma.create!(codigo: "TA_RES", disciplina: disciplina, docente: docente, semestre: "2026.1")
  @template = Template.create!(nome: "Avaliação Final", pessoa: @admin)
  @formulario = Formulario.create!(turma: @turma, template: @template, status: :fechado)
  @questao = Questao.create!(formulario: @formulario, enunciado: "O que achou da matéria?", tipo_resposta: "texto")
  pessoa_aluno = Pessoa.create!(usuario: "aluno_resultados", email: "aluno_resultados@unb.br", password: "123", password_confirmation: "123", nome: "Aluno Resultados")
  discente = Discente.create!(pessoa: pessoa_aluno, matricula: "20202020")
  Resposta.create!(questao: @questao, discente: discente, conteudo: "Muito boa!")
end

Quando('o administrador navega até a página de visualização de formulários') do
  visit admin_resultados_path
end

Então('o sistema deve exibir a lista contendo os formulários existentes') do
  # Verifica o nome da disciplina, que é o que o seu novo design mostra no cartão
  expect(page.body.downcase).to include(@formulario.turma.disciplina.nome.downcase)
end

Então('cada item da lista deve mostrar os detalhes do formulário, como nome e turma') do
  expect(page.body.downcase).to include(@formulario.turma.disciplina.nome.downcase)
  expect(page.body.downcase).to include("2026.1") # semestre
end

Então('o sistema deve disponibilizar um botão para gerar o relatório a partir das respostas daquele formulário') do
  expect(page).to have_selector("a[href='#{exportar_csv_admin_resultado_path(@formulario)}']")
end

Dado('que não há nenhum formulário criado ou registrado no banco de dados do sistema') do
  Formulario.destroy_all
end

Então('o sistema deve apresentar a tela sem nenhuma listagem de dados') do
  expect(page).not_to have_selector("a[href*='exportar_csv']")
end

Então('deve exibir a mensagem informativa {string}') do |mensagem|
  expect(page.body.downcase).to include(mensagem.downcase)
end