Dado('que existe um usuário com perfil de participante logado no sistema') do
  @pessoa = Pessoa.create!(email: "aluno@unb.br", password: "senha", password_confirmation: "senha", nome: "Aluno Teste", usuario: "123456789")
  @discente = Discente.create!(pessoa: @pessoa)
  visit login_path
  fill_in 'login', with: @pessoa.email
  fill_in 'password', with: 'senha'
  click_button 'Entrar'
end

Dado('que esse usuário possui vínculo ativo em uma turma') do
  pessoa_prof = Pessoa.create!(usuario: "prof123", email: "prof123@unb.br", password: "123", password_confirmation: "123", nome: "Professor Padrão")
  docente = Docente.create!(pessoa: pessoa_prof)
  @disciplina = Disciplina.create!(nome: "Engenharia de Software", codigo: "CIC0097")
  @turma = Turma.create!(codigo: "TA", disciplina: @disciplina, docente: docente)
  @turma.discentes << @discente
end

Dado('que existe um formulário de avaliação com status {string} para esta turma') do |status|
  @template = Template.create!(nome: "Avaliação Padrão", pessoa: @pessoa)
  @formulario = Formulario.create!(turma: @turma, template: @template, status: status.to_sym)
end

Dado('que o formulário possui questões onde a marcação {string} é verdadeira') do |obrigatoria|
  @questao = Questao.create!(formulario: @formulario, enunciado: "Como você avalia a didática do professor?", tipo_resposta: "texto")
end

Quando('o participante acessa a página do questionário da sua turma') do
  visit formulario_path(@formulario)
end

Quando('preenche todos os campos obrigatórios com respostas válidas') do
  fill_in "respostas[#{@questao.id}]", with: "Excelente didática!"
  @resposta_valida = true
end

Quando('deixa as questões obrigatórias em branco') do
  fill_in "respostas[#{@questao.id}]", with: ""
  @resposta_valida = false
end

Quando('aciona a opção de {string}') do |botao|
  click_button botao
end

Então('o sistema deve salvar as respostas do participante no banco de dados') do
  expect(Resposta.where(discente: @discente, questao: @questao)).to exist
end

Então('deve registrar o momento exato do envio') do
  expect(Resposta.find_by(discente: @discente, questao: @questao).created_at).not_to be_nil
end

Então('deve redirecionar o usuário exibindo uma mensagem de agradecimento pela avaliação') do
  expect([root_path, avaliacoes_path, "/"]).to include(current_path)
  expect(page).to have_content("sucesso")
end

Então('o sistema deve bloquear o envio do formulário') do
  expect([formulario_path(@formulario), "/avaliacoes", root_path, "/"]).to include(current_path)
end

Então('não deve criar nenhum registro de submissão no banco de dados') do
  expect(Resposta.where(discente: @discente, questao: @questao)).not_to exist
end

Então('deve exibir uma notificação de erro indicando quais campos obrigatórios precisam ser preenchidos') do
  expect(page.body).to include("obrigatórios precisam ser preenchidos")
end