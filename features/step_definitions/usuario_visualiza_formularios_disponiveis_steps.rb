Dado('que o participante esta logado no sistema') do
  @pessoa = Pessoa.create!(
    usuario: "participante_avaliacoes",
    email: "participante_avaliacoes@unb.br",
    password: "senha123",
    password_confirmation: "senha123",
    nome: "Participante Avaliacoes"
  )
  @discente = Discente.create!(pessoa: @pessoa, matricula: "20208888")

  visit login_path
  fill_in 'login', with: @pessoa.email
  fill_in 'password', with: "senha123"
  click_button 'Entrar'
end

Dado('esta matriculado em pelo menos uma turma ativa no periodo letivo atual') do
  pessoa_prof = Pessoa.create!(usuario: "prof_avaliacoes_disp", password: "123", password_confirmation: "123", nome: "Professor Avaliacoes")
  docente = Docente.create!(pessoa: pessoa_prof)

  disciplina = Disciplina.create!(nome: "Estrutura de Dados", codigo: "CIC0004")
  @turma = Turma.create!(codigo: "TA", disciplina: disciplina, docente: docente, semestre: "2026.1")

  TurmaDiscente.create!(turma: @turma, discente: @discente)
end

#-----HAPPY PATH ---

Dado('que existem formularios abertos e ainda nao respondidos para as turmas do participante') do
  admin = Pessoa.find_or_create_by!(usuario: "admin_avaliacoes_disp") do |p|
    p.email = "admin_avaliacoes_disp@unb.br"
    p.password = "123"
    p.password_confirmation = "123"
    p.nome = "Admin Avaliacoes Disp"
    p.admin = true
  end

  @template = Template.create!(nome: "Avaliação Estrutura de Dados", pessoa: admin)
  @formulario = Formulario.create!(turma: @turma, template: @template, status: :aberto)
end

Quando('o participante acessa a pagina de avaliacoes ou painel principal') do
  visit root_path
end

Então('o sistema deve exibir uma lista clara com todos os formularios pendentes') do
  expect(page).to have_content(@template.nome)
end

Então('deve permitir que o participante selecione o formulario desejado para iniciar a resposta') do
  expect(page).to have_selector("a[href='#{formulario_path(@formulario)}']")
end

#-----SAD PATH ---

Dado('que o participante ja respondeu a todos os formularios ou suas turmas nao possuem avaliacoes abertas') do
  Formulario.where(turma: @turma).destroy_all
end

Então('o sistema nao deve listar nenhum formulario para resposta') do
  expect(page).not_to have_selector("a[href^='/formularios/']")
end
