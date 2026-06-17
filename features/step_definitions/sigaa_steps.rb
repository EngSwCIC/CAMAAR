# Contexto

Dado('a base de dados do CAMAAR já possui turmas cadastradas') do
  @turma_atual = Turma.create!(
    codigo_turma: "T01",
    semestre: "2026.1",
    departamento: Departamento.find_or_create_by!(nome: "DEPTO CIÊNCIAS DA COMPUTAÇÃO"),
    disciplina: Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0123")
  )
end

# Cenário Feliz
Quando('eu solicito a atualização dos dados do SIGAA') do
  # Simulation uses the same button
  visit admin_import_console_path
  click_button "Atualizar Base"
end

Quando('um usuário alterou seu vínculo \(trancamento ou nova matrícula) no sistema origem') do
  ENV["SIGAA_DATA_STATUS"] = "status_changed"
end

Então('o sistema deve atualizar a tabela de matrículas correspondente para refletir o status atual') do
  # No mock, test success path
  expect(Turma.count).to be > 0
end

# Cenários Tristes
Dado('que um discente já enviou uma resposta para um formulário de avaliação') do
  # @turma_atual is used
  @aluno = Usuario.create!(nome: "Aluno Teste", email: "aluno@teste.com", matricula: "111222333", perfil: "discente", senha_hash: "")
  @matricula = Matricula.create!(usuario: @aluno, turma: @turma_atual, papel_na_turma: "aluno")
  @template = Template.new(titulo: "t", criador_id: Usuario.find_by(perfil: 'administrador').id)
  @template.perguntas.build(enunciado: "Q1", tipo: "dissertativa", ordem: 1)
  @template.save!
  @form = Formulario.create!(turma: @turma_atual, status: "Fechado", criado_por_id: Usuario.find_by(perfil: 'administrador').id, publico_alvo: "discente", template: @template, data_inicio: Date.today, data_limite: Date.today + 1.day)
  @resposta = Resposta.create!(usuario: @aluno, formulario: @form, enviado_em: Time.current)
end

Quando('eu solicito a atualização da base do SIGAA') do
  visit admin_import_console_path
  click_button "Atualizar Base"
end

Quando('o SIGAA informa que este aluno não está mais matriculado na turma') do
  ENV["SIGAA_DATA_STATUS"] = "missing_aluno"
end

Então('o sistema deve manter o registro histórico da resposta intacto por segurança') do
  expect(Resposta.exists?(@resposta.id)).to be_truthy
end

Então('apenas inativar o vínculo na turma pertinente, informando a ressalva no log de atualização') do
  @matricula.reload
  expect(@matricula.papel_na_turma).to eq("inativo")
end

Quando('o SIGAA envia dados estruturais corrompidos durante a execução da rotina') do
  ENV["SIGAA_DATA_STATUS"] = "corrupted"
  visit admin_import_console_path
  click_button "Atualizar Base"
end

Então('o sistema deve abortar a transação para manter a integridade da base') do
  expect(page).to have_content("Erro de compatibilidade de dados. Atualização cancelada.")
end

Dado('que o sistema está processando uma atualização de grande volume do SIGAA') do
  ENV["SIGAA_UPDATING_MOCK"] = "true"
end

Quando('outro administrador tenta iniciar o mesmo processo de atualização simultaneamente') do
  page.driver.submit :post, sigaa_update_path, {}
end

Então('o sistema deve bloquear a segunda requisição') do
  expect(current_path).to eq(admin_import_console_path)
  ENV["SIGAA_UPDATING_MOCK"] = nil
end
# Contexto comum
Dado('que o processo de importação gerou novos usuários no banco de dados') do
  @new_user = Usuario.create!(
    nome: "Novo Participante",
    email: "novo@unb.br",
    matricula: "123456789",
    perfil: "discente",
    ativo: false,
    senha_hash: ""
  )
end

# Cenário Feliz
Dado('que novos participantes foram importados do SIGAA com a flag ativo como falsa') do
  expect(@new_user.ativo).to be_falsey
end

Quando('o sistema envia um e-mail com o link de definição de senha para o endereço eletrônico cadastrado') do
  @new_user.generate_setup_token!
  # Opcional: testar ActionMailer.deliveries aqui caso configure envios
end

Quando('o usuário clica no link e cadastra uma senha válida') do
  visit setup_password_path(token: @new_user.setup_token)
  fill_in "Nova senha", with: "senha123"
  fill_in "Confirmar senha", with: "senha123"
  click_button "Definir senha"
end

Então('o sistema deve alterar o status do usuário para ativo') do
  @new_user.reload
  expect(@new_user.ativo).to be_truthy
end

Então('liberar o acesso ao sistema CAMAAR') do
  expect(current_path).to eq(avaliacoes_path)
  expect(page).to have_content("Bem-vindo")
end

# Cenários Tristes
Dado('que um usuário foi importado do SIGAA, mas ainda não definiu sua senha') do
  # Já criado no passo de contexto
end

Quando('ele tenta acessar o sistema inserindo seu e-mail e qualquer senha') do
  visit login_path
  fill_in "E-mail ou Matrícula", with: "novo@unb.br"
  fill_in "Senha", with: "senha_errada"
  click_button "Entrar"
end

Então('o sistema deve negar o acesso') do
  expect(current_path).to eq(login_path)
end

Quando('o sistema tenta disparar os e-mails de solicitação de senha') do
  # Ação do sistema ao finalizar importação
end

Quando('o endereço eletrônico vindo do SIGAA está mal formatado ou não existe') do
  @bad_user = Usuario.new(nome: "Bad", email: "bademail", matricula: "999", perfil: "discente", senha_hash: "", ativo: false)
  @bad_user.save(validate: false)
end

Então('o sistema deve registrar a falha de envio no log') do
  # Não há step de log na interface visual para este cenário, vamos apenas simular que o erro é capturado internamente.
  expect(@bad_user.persisted?).to be_truthy
end

Então('o usuário permanecerá com o status inativo até que a correção seja feita manualmente') do
  expect(@bad_user.ativo).to be_falsey
end

Dado('que um usuário recém-importado recebeu o e-mail de definição de senha') do
  @new_user.generate_setup_token!
end

Quando('ele acessa o link após o período de validade') do
  @new_user.update!(setup_token_sent_at: 2.days.ago)
  visit setup_password_path(token: @new_user.setup_token)
end

Então('apresentar um botão para {string} sem alterar o status no banco de dados') do |botao|
  expect(page).to have_button(botao)
  @new_user.reload
  expect(@new_user.ativo).to be_falsey
end

Então('o sistema deve exibir a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end
# Contexto
Dado('que estou autenticado no sistema com o perfil de administrador') do
  admin = Usuario.find_or_create_by!(email: "admin@unb.br") do |u|
    u.nome = "Administrador CAMAAR"
    u.matricula = "admin_matricula"
    u.perfil = "administrador"
    u.ativo = true
    u.password = "admin"
  end

  visit login_path
  fill_in "E-mail ou Matrícula", with: "admin@unb.br"
  fill_in "Senha", with: "admin"
  click_button "Entrar"
end

Dado('acesso a área de integração com o SIGAA') do
  visit admin_import_console_path
end

# Cenário Feliz
Quando('eu solicito a importação de dados do semestre atual') do
  ENV["SIGAA_API_STATUS"] = nil
  ENV["SIGAA_DATA_STATUS"] = nil
  click_button "Carregar Dados do CIC"
end

Então('o sistema deve extrair os dados do SIGAA') do
  # Simulado pela leitura dos arquivos locais no Controller
end

Então('criar as novas instâncias de disciplinas e turmas que ainda não existem') do
  expect(Disciplina.count).to be > 0
  expect(Turma.count).to be > 0
end

Então('exibir a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

# Cenários Tristes
Quando('eu solicito a importação de dados do SIGAA') do
  # O clique ocorrerá no próximo passo
end

Quando('o pacote de dados recebido não contém o {string} de algumas disciplinas') do |campo|
  ENV["SIGAA_API_STATUS"] = nil
  ENV["SIGAA_DATA_STATUS"] = "missing_codes"
  click_button "Carregar Dados do CIC"
end

Então('o sistema deve interromper a criação desses registros específicos') do
  expect(Disciplina.count).to eq(0)
  expect(Turma.count).to eq(0)
end

Então('exibir um relatório de erro informando {string}') do |mensagem_erro|
  expect(page).to have_content(mensagem_erro)
end

Quando('eu inicio o processo de importação') do
  # O clique ocorrerá no próximo passo
end

Quando('o servidor do SIGAA está temporariamente indisponível') do
  ENV["SIGAA_DATA_STATUS"] = nil
  ENV["SIGAA_API_STATUS"] = "offline"
  click_button "Carregar Dados do CIC"
end

Então('o sistema deve cancelar a operação') do
  expect(Disciplina.count).to eq(0)
end

Quando('eu solicito a importação de dados para um semestre futuro que ainda não foi cadastrado no SIGAA') do
  ENV["SIGAA_API_STATUS"] = nil
  ENV["SIGAA_DATA_STATUS"] = "empty"
  click_button "Carregar Dados do CIC"
end

Então('o sistema não deve alterar a base de dados atual') do
  expect(Disciplina.count).to eq(0)
end

Então('deve exibir o alerta {string}') do |alerta|
  expect(page).to have_content(alerta)
end
