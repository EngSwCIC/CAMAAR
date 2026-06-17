Dado('que os dados do SIGAA para o semestre atual {string} foram sincronizados') do |semestre|
  @semestre_atual = semestre
end

Dado('existem turmas cadastradas para o departamento {string}') do |nome_departamento|
  sufixo = nome_departamento.include?("CIC") ? "cic" : "mat"
  pessoa_prof = Pessoa.find_or_create_by!(usuario: "prof_#{sufixo}") do |p|
    p.password = "123"
    p.password_confirmation = "123"
    p.nome = "Professor #{sufixo}"
  end
  docente = Docente.find_or_create_by!(pessoa: pessoa_prof)
  docente.update!(departamento: nome_departamento)

  if nome_departamento.include?("CIC")
    disciplina = Disciplina.find_or_create_by!(codigo: "CIC0100", nome: "Engenharia de Software")
    Turma.find_or_create_by!(codigo: "TA_CIC", disciplina: disciplina, docente: docente)
  elsif nome_departamento.include?("MAT")
    disciplina_mat = Disciplina.find_or_create_by!(codigo: "MAT0001", nome: "Cálculo 1")
    @turma_mat = Turma.find_or_create_by!(codigo: "TA_MAT", disciplina: disciplina_mat, docente: docente)
  end
end

Dado('existe um usuário {string} autenticado com perfil de {string}') do |nome_usuario, perfil|
  @admin_cic = Pessoa.create!(
    email: "admin_cic@unb.br",
    password: "senha",
    password_confirmation: "senha",
    nome: nome_usuario,
    usuario: "admin_cic",
    admin: (perfil == "Administrador")
  )
  visit login_path
  fill_in 'login', with: @admin_cic.email
  fill_in 'password', with: "senha"
  click_button 'Entrar'
end

Dado('o usuário {string} está vinculado institucionalmente ao departamento {string}') do |nome_usuario, nome_departamento|
  docente_admin = Docente.find_or_create_by!(pessoa: @admin_cic)
  docente_admin.update!(departamento: nome_departamento)
end

#-----HAPPY PATH ---


Dado('que o {string} acessa o painel de gerenciamento de turmas do semestre atual') do |usuario|
  visit new_admin_formulario_path
end

Quando('a listagem de turmas for carregada na tela') do
  expect(page).to have_css('body')
end

Então('ele deve visualizar as disciplinas referentes ao departamento {string}, como {string}') do |depto, nome_disciplina|
  expect(page).to have_content(nome_disciplina)
end

Então('a lista não deve exibir nenhuma disciplina referente ao departamento {string}, como {string}') do |depto, nome_disciplina|
  expect(page).not_to have_content(nome_disciplina)
end

#-----SAD PATH ---

Dado('que a turma de {string} pertence ao departamento {string} e possui o ID de sistema {string}') do |disciplina, depto, id_turma|
  @turma_mat.update!(id: id_turma.to_i)
end

Quando('o {string} tenta forçar o acesso digitando diretamente a URL {string}') do |usuario, url_acesso|
  template = Template.find_or_create_by!(nome: "Template Fantasma", pessoa: @admin_cic)
  TemplateQuestao.find_or_create_by!(template: template, enunciado: "Q1", tipo_resposta: "texto")
  page.driver.submit :post, admin_formularios_path, { turma_ids: [@turma_mat.id], template_id: template.id }
end

Então('o sistema deve interceptar a requisição e bloquear o acesso') do
end

Então('deve redirecionar o usuário para o painel principal do seu departamento') do
  expect(current_path).to eq(admin_root_path)
end

Então('exibir a mensagem de erro {string}') do |mensagem_erro|
  expect(page).to have_content(mensagem_erro)
end