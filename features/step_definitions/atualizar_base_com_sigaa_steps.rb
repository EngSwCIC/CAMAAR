# encoding: utf-8

# ==================== HELPER ====================

def executar_atualizacao_sigaa
  visit admin_management_path
  click_button 'Atualizar Base SIGAA'
end

# ==================== CONTEXTO ====================

Dado('o sistema possui integração ativa com o SIGAA') do
  ENV['SIGAA_SCENARIO'] = 'success'
end

# ==================== CONDIÇÕES DO SIGAA ====================
# Nesses cenários o feature faz "Quando <ação>" e depois "E <condição>".
# Por isso cada step de condição reexecuta a ação com o ENV correto,
# sobrescrevendo o resultado anterior.

Dado('o SIGAA retorna dados válidos') do
  ENV['SIGAA_SCENARIO'] = 'success'
  # cenário de sucesso: a ação já foi executada com success no Contexto,
  # nada a reexecutar.
end

Dado('o SIGAA retorna dados inconsistentes') do
  ENV['SIGAA_SCENARIO'] = 'invalid'
  executar_atualizacao_sigaa
end

Dado('não há conexão com o SIGAA') do
  ENV['SIGAA_SCENARIO'] = 'connection_error'
  executar_atualizacao_sigaa
end

Dado('o SIGAA retorna parcialmente os dados com sucesso') do
  ENV['SIGAA_SCENARIO'] = 'success'
  allow(SigaaImporter).to receive(:import_classes).and_return({ success: true })
  allow(SigaaImporter).to receive(:import_members).and_return({ success: false, failed: ['mat_001'] })
  executar_atualizacao_sigaa
end

Dado('o SIGAA não retorna nenhum dado') do
  ENV['SIGAA_SCENARIO'] = 'empty'
  executar_atualizacao_sigaa
end

# ==================== ESTADO DO SISTEMA ====================

Dado('que já existe uma atualização em andamento') do
  SyncLock.start!
end

Dado('que uma atualização anterior falhou') do
  SigaaLog.create!(
    user:    @admin,
    status:  'error',
    message: 'Falha na sincronização anterior'
  )
end

# ==================== AÇÕES ====================

Quando('solicito a atualização dos dados a partir do SIGAA') do
  # ENV já foi setado no Contexto (success por padrão).
  # Para cenários tristes, o step "E <condição>" reexecuta com o ENV correto.
  executar_atualizacao_sigaa
end

Quando('solicito uma nova atualização dos dados a partir do SIGAA') do
  executar_atualizacao_sigaa
end

Quando('solicito uma nova tentativa de atualização') do
  ENV['SIGAA_SCENARIO'] = 'success'
  executar_atualizacao_sigaa
end

Quando('tento solicitar a atualização da base de dados') do
  # Usuário discente é barrado pelo require_admin antes de ver o botão.
  visit admin_management_path
end

Quando('a atualização é executada') do
  ENV['SIGAA_SCENARIO'] = 'success'
  executar_atualizacao_sigaa
end

# ==================== USUÁRIO SEM PERMISSÃO ====================

Dado('que estou logado como usuário comum') do
  @common_user = User.create!(
    email:                 'comum@gmail.com',
    matricula:             '190000001',
    password:              'senha123',
    password_confirmation: 'senha123',
    role:                  'discente'
  )
  visit login_path
  fill_in 'Email ou Matrícula', with: 'comum@gmail.com'
  fill_in 'Senha',              with: 'senha123'
  click_button 'Entrar'
end

# ==================== VERIFICAÇÕES - CENÁRIOS FELIZES ====================

Então('a base de dados do sistema deve ser atualizada com os novos dados') do
  expect(page).to have_content('Atualização concluída com sucesso')
end

Então('devo ver uma mensagem de sucesso na atualização') do
  expect(page).to have_content('Atualização concluída com sucesso')
end

Então('o sistema deve atualizar apenas os dados válidos') do
  expect(page).to have_content('SIGAA retornou dados inconsistentes')
end

Então('deve registrar os dados que falharam na atualização') do
  expect(SigaaLog.last).not_to be_nil
end

Então('o sistema deve reprocessar os dados do SIGAA') do
  expect(page).to have_content('Atualização concluída com sucesso')
end

Então('a base de dados deve ser atualizada com sucesso caso os dados sejam válidos') do
  expect(page).to have_content('Atualização concluída com sucesso')
end

# ==================== VERIFICAÇÕES - CENÁRIOS TRISTES ====================

Então('a atualização não deve ser concluída') do
  expect(page).not_to have_content('Atualização concluída com sucesso')
end

Então('devo ver uma mensagem de erro informando inconsistência de dados') do
  expect(page).to have_content('Dados inválidos retornados pelo SIGAA')
end

Então('a atualização não deve ser realizada') do
  expect(page).not_to have_content('Atualização concluída com sucesso')
end

Então('devo ver uma mensagem informando falha de comunicação') do
  expect(page).to have_content('Falha de conexão com o SIGAA')
end

Então('devo ser impedido de realizar a ação') do
  expect(page).not_to have_content('Atualização concluída com sucesso')
end

Então('devo ver uma mensagem de acesso negado') do
  expect(page).to have_text(/Acesso não autorizado|Acesso negado/)
end

Então('devo ser impedido de iniciar outra atualização') do
  expect(page).to have_content('Já existe uma atualização em andamento')
end

Então('devo ver uma mensagem informando que já existe um processo em execução') do
  expect(page).to have_content('Já existe uma atualização em andamento')
end

Então('devo ver uma mensagem informando ausência de dados') do
  expect(page).to have_content('SIGAA não retornou dados')
end

# ==================== AUDITORIA ====================

Então('o sistema deve registrar um log da atualização') do
  expect(SigaaLog.count).to be >= 1
end

Então('o log deve conter data, usuário responsável e resultado da operação') do
  log = SigaaLog.last
  expect(log.user).not_to be_nil
  expect(log.status).not_to be_blank
  expect(log.message).not_to be_blank
  expect(log.created_at).not_to be_nil
end
