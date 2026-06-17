# encoding: utf-8

# ==================== CONTEXTO ====================

# Dado('que estou logado como Administrador')
# Dado('estou na página {string}')
# Dado('clico no botão {string}')
# Dado('que estou logado como Discente')
# Então('vejo a mensagem de sucesso {string}')
# Então('vejo a mensagem de erro {string}')
# Então('o modal permanece aberto')
# Então('o modal é fechado')
# Então('sou redirecionado para o painel do usuário')

Dado('que existem turmas cadastradas no sistema') do
  @disciplina = Disciplina.create!(
    code: 'CIC0001',
    name: 'Engenharia de Software'
  )

  @docente = User.create!(
    email:                 'prof.fulano@unb.br',
    matricula:             '111000001',
    password:              'senhaDocente',
    password_confirmation: 'senhaDocente',
    role:                  'docente',
    nome:                  'Prof. Fulano'
  )

  @turma1 = Turma.create!(
    classCode:  'CIC1024',
    semester:   '2024.1',
    time:       '10:00',
    disciplina: @disciplina,
    nome:       'Estudos Em'
  )
  @turma1.docentes << @docente

  @turma2 = Turma.create!(
    classCode:  'CIC1025',
    semester:   '2024.1',
    time:       '14:00',
    disciplina: @disciplina,
    nome:       'Estudos Em'
  )
  @turma2.docentes << @docente

  @template = Template.create!(name: 'Avaliação de Monitoria')
  @template.questions.create!(kind: 'radio', text: 'Como você avalia a didática?')
end

Dado('que existem ao menos duas turmas cadastradas no sistema') do
  step 'que existem turmas cadastradas no sistema'
end

Dado('que não existem turmas cadastradas no sistema') do
  Turma.destroy_all
  @template = Template.create!(name: 'Avaliação de Monitoria')
end

Dado('que o formulário baseado no template {string} foi enviado para a turma {string}') do |nome_template, codigo_turma|
  step 'que existem turmas cadastradas no sistema'

  @form = Form.create!(
    template:   @template,
    start_date: 1.day.ago,
    end_date:   1.day.from_now
  )
  turma = Turma.find_by(classCode: codigo_turma) || @turma1
  @form.turmas << turma
end

Dado('que o formulário foi enviado para a turma {string}') do |codigo_turma|
  step "que o formulário baseado no template \"Avaliação de Monitoria\" foi enviado para a turma \"#{codigo_turma}\""
end

# ==================== VERIFICAÇÕES DO MODAL ====================

Então('um modal é exibido com um dropdown de {string} e uma tabela de turmas') do |campo|
  expect(page).to have_selector('.modal')
  expect(page).to have_select(campo)
  expect(page).to have_selector('.modal table')
end

Então('o modal exibe o campo {string} com um dropdown') do |campo|
  within('.modal') do
    expect(page).to have_select(campo)
  end
end

Então('o modal exibe uma tabela com as colunas {string}, {string} e {string}') do |col1, col2, col3|
  within('.modal table thead') do
    expect(page).to have_content(col1)
    expect(page).to have_content(col2)
    expect(page).to have_content(col3)
  end
end

Então('cada linha da tabela possui um checkbox para seleção') do
  within('.modal table tbody') do
    all('tr').each do |row|
      expect(row).to have_selector("input[type='checkbox']")
    end
  end
end

Então('vejo o botão {string}') do |botao|
  expect(page).to have_button(botao)
end

# ==================== AÇÕES — PREENCHIMENTO DO MODAL ====================

Quando('seleciono o template {string} no dropdown {string}') do |template, campo|
  within('.modal') do
    select template, from: campo
  end
end

Quando('não seleciono nenhum template no dropdown {string}') do |campo|
  within('.modal') do
    expect(find("select[name='template']").value).to be_blank
  end
end

Quando('marco o checkbox da turma {string} com semestre {string} e código {string}') do |nome, semestre, codigo|
  within('.modal table tbody') do
    row = find('tr', text: codigo)
    within(row) do
      find("input[type='checkbox']").check
    end
  end
end

Quando('marco o checkbox da segunda turma {string} com semestre {string} e código {string}') do |nome, semestre, codigo|
  within('.modal table tbody') do
    rows = all('tr', text: nome)
    within(rows.last) do
      find("input[type='checkbox']").check
    end
  end
end

Quando('não marco o checkbox de nenhuma turma na tabela') do
  within('.modal table tbody') do
    all("input[type='checkbox']").each do |checkbox|
      expect(checkbox).not_to be_checked
    end
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
  turma = Turma.find_by(classCode: codigo_turma) || @turma1

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
  fill_in 'email',    with: 'discente.form@gmail.com'
  fill_in 'password', with: 'senhaDicente'
  click_button 'Entrar'

  visit avaliacoes_path
end

Então('o discente visualiza o card da turma {string} disponível para resposta') do |codigo_turma|
  expect(page).to have_selector('.turma-card', text: codigo_turma)
end

Então('o Discente acessou o card da turma {string}') do |codigo_turma|
  within('.turma-card', text: codigo_turma) do
    click_on codigo_turma
  end
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
end

Então('a resposta é registrada no sistema') do
  expect(FormResponse.count).to be >= 1
  expect(FormResponse.last.user).to eq(@discente)
end

Então('o resultado fica disponível na tela {string} do Administrador') do |pagina|
  # Faz logout do discente e login como admin para verificar
  click_on 'Logout' if page.has_link?('Logout')
  visit login_path
  fill_in 'email',    with: 'admin@gmail.com'
  fill_in 'password', with: 'senhaAdmin'
  click_button 'Entrar'

  visit admin_results_path
  expect(page).to have_selector('.turma-card')
end

# ==================== VERIFICAÇÕES — CENÁRIOS TRISTES ====================

Então('a tabela de turmas está vazia') do
  within('.modal table tbody') do
    expect(page).not_to have_selector('tr')
  end
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o botão {string} está desabilitado') do |botao|
  expect(page).to have_button(botao, disabled: true)
end

Quando('tento acessar a página {string}') do |pagina|
  case pagina
  when 'Gerenciamento'
    visit admin_management_path
  when 'Gerenciamento - Templates'
    visit admin_templates_path
  when 'Gerenciamento - Resultados'
    visit admin_results_path
  end
end