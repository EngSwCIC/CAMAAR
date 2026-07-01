# encoding: utf-8
#
# Steps da feature "Gerar formulário de avaliação" (#6). Reaproveita os
# steps compartilhados de "criacao_form_para_dic_doc_steps.rb" e
# "shared_steps.rb" para o preenchimento e validação do modal — ambas as
# features usam a mesma UI (modal com Tipo de Destinatário, Template,
# Turma(s) e datas de vigência).

# ==================== CONTEXTO — TURMAS SEM FORMULÁRIO ====================

Dado('que não existem turmas cadastradas no sistema') do
  Turma.destroy_all
  Template.find_or_create_by!(nome: 'Avaliação Engenharia de Software')
  visit admin_management_path if current_path == admin_management_path
end

Dado('que o formulário baseado no template {string} foi enviado para a turma {string}') do |nome_template, codigo_turma|
  step 'que existem turmas e templates para criação de formulários'

  template = Template.find_by(nome: nome_template) || Template.create!(nome: nome_template)
  @form = Form.create!(
    template:     template,
    destinatario: 'discente',
    start_date:   1.day.ago,
    end_date:     1.day.from_now
  )
  turma = Turma.find_by(classCode: codigo_turma) || @turma_cic0105
  @form.turmas << turma
end

Dado('que o formulário foi enviado para a turma {string}') do |codigo_turma|
  step "que o formulário baseado no template \"Avaliação Engenharia de Software\" foi enviado para a turma \"#{codigo_turma}\""
end

# ==================== VERIFICAÇÕES DO MODAL ====================

Então('o modal exibe o campo {string} com um dropdown') do |campo|
  within('.modal') do
    expect(page).to have_select(campo)
  end
end

Então('o modal exibe o campo {string} com um seletor de múltipla escolha') do |campo|
  within('.modal') do
    select_field = find_field(campo)
    expect(select_field[:multiple]).to be_truthy
  end
end

# ==================== VERIFICAÇÕES — CENÁRIOS FELIZES ====================

Então('o formulário fica disponível para os discentes da turma {string}') do |codigo_turma|
  form = Form.last
  expect(form).not_to be_nil
  expect(form.turmas.pluck(:classCode)).to include(codigo_turma)
end

Então('o formulário fica disponível para os discentes das duas turmas selecionadas') do
  form = Form.last
  expect(form.turmas.count).to be >= 2
end

Então('um Discente matriculado na turma {string} acessa o painel de Avaliações') do |codigo_turma|
  turma = Turma.find_by(classCode: codigo_turma) || @turma_cic0105

  @discente = User.create!(
    email:                 'discente.form@gmail.com',
    matricula:             '190084020',
    password:              'senhaDicente',
    password_confirmation: 'senhaDicente',
    role:                  'discente',
    nome:                  'Discente Form'
  )
  @discente.turmas << turma

  visit login_path
  fill_in 'Email ou Matrícula', with: 'discente.form@gmail.com'
  fill_in 'Senha', with: 'senhaDicente'
  click_button 'Entrar'

  visit avaliacoes_path
end

Então('o discente visualiza o card da turma {string} disponível para resposta') do |codigo_turma|
  expect(page).to have_selector('.turma-card', text: codigo_turma)
end

Então('o Discente acessou o card da turma {string}') do |codigo_turma|
  turma = Turma.find_by(classCode: codigo_turma)

  @discente ||= User.create!(
    email:                 'discente.resposta@gmail.com',
    matricula:             '190084021',
    password:              'senhaDicente',
    password_confirmation: 'senhaDicente',
    role:                  'discente',
    nome:                  'Discente Resposta'
  )
  @discente.turmas << turma unless @discente.turmas.include?(turma)

  visit login_path
  fill_in 'Email ou Matrícula', with: 'discente.resposta@gmail.com'
  fill_in 'Senha', with: 'senhaDicente'
  click_button 'Entrar'

  visit avaliacoes_path

  within('.turma-card', text: codigo_turma) do
    click_on codigo_turma
  end

  click_on 'Responder Agora'
end

Quando('o Discente responde as questões exibidas e clica no botão de envio') do
  all('.questao').each do |questao|
    if questao.has_selector?("input[type='radio']")
      questao.first("input[type='radio']").choose
    elsif questao.has_selector?("input[type='text'], textarea")
      questao.first("input[type='text'], textarea").fill_in with: 'Resposta de teste'
    end
  end
  find('.btn-enviar-formulario').click

  # Com o driver @javascript a submissão é assíncrona (navegação real do
  # browser): sem esperar aqui, o step seguinte pode consultar o banco
  # (FormResponse.count) antes do controller terminar de processar o
  # `responder` e persistir o registro, causando falha intermitente
  # ("got 0" mesmo quando o registro é criado pouco depois). Aguardamos
  # explicitamente a mensagem de sucesso na página de destino para garantir
  # que a requisição já foi concluída antes de seguir para a asserção.
  expect(page).to have_content('Avaliação submetida com sucesso!')
end

Então('a resposta é registrada no sistema') do
  expect(FormResponse.count).to be >= 1
  expect(FormResponse.last.user).to eq(@discente)
end

Então('o resultado fica disponível na tela {string} do Administrador') do |pagina|
  # Faz logout do discente e login como admin para verificar
  click_on 'Logout' if page.has_link?('Logout')
  visit login_path
  fill_in 'Email ou Matrícula', with: 'admin@gmail.com'
  fill_in 'Senha', with: 'senhaAdmin'
  click_button 'Entrar'

  visit admin_results_path
  expect(page).to have_selector('.turma-card')
end

# ==================== VERIFICAÇÕES — CENÁRIOS TRISTES ====================

Então('o botão {string} está desabilitado') do |botao|
  expect(page).to have_button(botao, disabled: true)
end
