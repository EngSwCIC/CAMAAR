# encoding: utf-8

# ==================== CONTEXTO ====================

Dado('que estou logado como Participante') do
  @user = User.create!(
    email:                 'participante@gmail.com',
    matricula:             '190084010',
    password:              'senhaParticipante',
    password_confirmation: 'senhaParticipante',
    role:                  'discente'
  )
  
  visit login_path
  fill_in 'email', with: 'participante@gmail.com'
  fill_in 'password', with: 'senhaParticipante'
  click_button 'Entrar'
end

Então('vejo uma seção com os formulários não respondidos das minhas turmas') do
  expect(page).to have_selector('.formularios-nao-respondidos')
end

# ==================== CENÁRIOS FELIZES - AÇÕES ====================

Quando('acesso a página {string}') do |pagina|
  case pagina
  when 'Avaliações'
    visit avaliacoes_path
  else
    visit '/'
  end
end

Então('vejo uma lista com cards de formulários não respondidos') do
  expect(page).to have_selector('.form-card')
end

Então('cada card exibe {string}, {string}, {string} e um botão {string}') do |info1, info2, info3, botao|
  card = find('.form-card')
  expect(card).to have_content(info1) # Turma
  expect(card).to have_content(info2) # Template
  expect(card).to have_content(info3) # Data de Término
  expect(card).to have_button(botao)
end

Então('os formulários são agrupados por turma') do
  expect(page).to have_selector('.turma-group')
end

Dado('que existem formulários não respondidos') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação de Engenharia de Software',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
end

Quando('clico no card de um formulário') do
  click_link find('.form-card').text
end

Então('vejo os detalhes completos como {string}, {string}, {string}, {string}') do |info1, info2, info3, info4|
  expect(page).to have_content(info1) # Turma
  expect(page).to have_content(info2) # Template
  expect(page).to have_content(info3) # Data de Início
  expect(page).to have_content(info4) # Data de Término
end

Então('vejo um botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Então('vejo a quantidade de questões do formulário') do
  expect(page).to have_content('questões')
end

Dado('que estou matriculado em múltiplas turmas com formulários') do
  @class1 = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  @class2 = Class.create!(
    code:     'CIC0202',
    name:     'Banco de Dados',
    semester: '2026.1'
  )
  
  @user.classes << [@class1, @class2]
  
  @form1 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação 1',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form1.classes << @class1
  
  @form2 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação 2',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form2.classes << @class2
end

Quando('seleciono a turma {string} no filtro') do |turma|
  select turma, from: 'filtro_turma'
end

Então('a lista exibe apenas os formulários da turma {string}') do |turma|
  expect(page).to have_content(turma)
end

Então('os formulários de outras turmas deixam de aparecer') do
  expect(page).not_to have_selector('.form-card', count: 2)
end

Dado('que sou um Dicente com formulários para dicentes e também Docente com formulários para docentes') do
  @user_dicente = User.create!(
    email:                 'user_dicente@gmail.com',
    matricula:             '190084011',
    password:              'senha',
    password_confirmation: 'senha',
    role:                  'discente'
  )
  
  @user_docente = User.create!(
    email:                 'user_docente@gmail.com',
    matricula:             '190084012',
    password:              'senha',
    password_confirmation: 'senha',
    role:                  'docente'
  )
  
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user_dicente.classes << @class
  @user_docente.classes << @class
  
  @form_dicente = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação para Dicentes',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form_dicente.classes << @class
  
  @form_docente = Form.create!(
    destiny_type: 'docente',
    template_name: 'Avaliação para Docentes',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form_docente.classes << @class
end

Quando('seleciono {string} no filtro {string}') do |opcao, filtro|
  select opcao, from: filtro
end

Então('a lista exibe apenas os formulários destinados a dicentes') do
  expect(page).to have_content('Avaliação para Dicentes')
end

Então('os formulários para docentes deixam de aparecer') do
  expect(page).not_to have_content('Avaliação para Docentes')
end

Dado('que existem múltiplos formulários com datas diferentes') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form1 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Formulário 1',
    start_date: 5.days.ago,
    end_date: 5.days.from_now
  )
  @form1.classes << @class
  
  @form2 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Formulário 2',
    start_date: 2.days.ago,
    end_date: 2.days.from_now
  )
  @form2.classes << @class
end

Quando('clico no filtro {string}') do |filtro|
  click_button filtro
end

Quando('seleciono {string}') do |opcao|
  click_link opcao
end

Então('os formulários aparecem ordenados por data de término (mais próximos primeiro)') do
  cards = all('.form-card')
  expect(cards.first).to have_content('2 dias') # Mais próximo
end

Dado('que existe um formulário com deadline em 2 dias') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 2.days.from_now
  )
  
  @form.classes << @class
end

Quando('visualizo o card do formulário') do
  visit avaliacoes_path
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o card exibe uma barra de progresso de tempo em cor verde') do
  expect(page).to have_selector('.progress-bar.verde')
end

Dado('que existe um formulário vencendo em 1 hora') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Urgente',
    start_date: 1.day.ago,
    end_date: 1.hour.from_now
  )
  
  @form.classes << @class
end

Então('vejo a mensagem de alerta {string}') do |mensagem|
  expect(page).to have_selector('.alert', text: mensagem)
end

Então('o card exibe uma barra de progresso de tempo em cor vermelha') do
  expect(page).to have_selector('.progress-bar.vermelha')
end

Dado('que estou visualizando um formulário não respondido') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
  
  visit avaliacoes_path
  click_button 'Responder'
end

# Removed duplicate click step

Então('sou redirecionado para a página de preenchimento do formulário') do
  expect(page).to have_current_path(responder_form_path(@form), wait: 10)
end

Então('vejo todas as questões do template') do
  expect(page).to have_selector('.questao')
end

Então('vejo o botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Dado('que estou preenchendo um formulário') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
  
  visit responder_form_path(@form)
end

Quando('preencho algumas questões') do
  fill_in 'Questão 1', with: 'Resposta 1'
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('sou redirecionado para a lista de formulários') do
  expect(page).to have_current_path(avaliacoes_path, wait: 10)
end

Então('o card do formulário exibe {string}') do |status|
  expect(page).to have_content(status)
end

Dado('que salvei um formulário como rascunho anteriormente') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
  
  @draft = FormResponse.create!(
    form: @form,
    user: @user,
    status: 'draft',
    answers: { 'q1' => 'Resposta anterior' }
  )
end

Então('vejo o formulário com os dados previamente preenchidos') do
  expect(page).to have_field(with: 'Resposta anterior')
end

Então('vejo um botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Então('as respostas anteriores estão mantidas') do
  expect(page).to have_field(with: 'Resposta anterior')
end

Então('vejo um resumo no topo da página') do
  expect(page).to have_selector('.resumo-avaliacoes')
end

Então('vejo a informação {string}') do |informacao|
  expect(page).to have_content(informacao)
end

Então('vejo um percentual de progresso') do
  expect(page).to have_selector('.progress-percentage')
end

Então('vejo a aba {string} selecionada por padrão') do |aba|
  expect(page).to have_selector(".nav-tabs .active", text: aba)
end

Então('vejo a aba {string} com formulários salvos como rascunho') do |aba|
  click_link aba
  expect(page).to have_selector('.form-card')
end

Então('vejo a aba {string} com formulários já submetidos') do |aba|
  click_link aba
  expect(page).to have_selector('.form-card')
end

Então('posso clicar para mudar entre abas') do
  all('.nav-tabs a').each do |aba|
    aba.click
    expect(page).to have_selector('.tab-pane.active')
  end
end

# ==================== CENÁRIOS TRISTES ====================

Dado('que respondeu todos os formulários das suas turmas') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
  
  # Marca como respondido
  FormResponse.create!(
    form: @form,
    user: @user,
    status: 'submitted'
  )
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('a lista está vazia') do
  expect(page).not_to have_selector('.form-card')
end

Então('vejo o botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Dado('que tentei acessar um formulário através de um link antigo') do
  # Simula tentativa de acesso
  true
end

Quando('abro o link de um formulário da turma {string} em que não estou matriculado') do |turma|
  @other_class = Class.create!(
    code:     turma,
    name:     'Outra Turma',
    semester: '2026.1'
  )
  
  @other_form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @other_form.classes << @other_class
  
  visit responder_form_path(@other_form)
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('sou redirecionado para a página {string}') do |pagina|
  case pagina
  when 'Avaliações'
    expect(page).to have_current_path(avaliacoes_path, wait: 10)
  end
end

Dado('que existe um formulário com deadline já vencido há 1 dia') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @expired_form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Expirada',
    start_date: 3.days.ago,
    end_date: 1.day.ago
  )
  
  @expired_form.classes << @class
end

Então('o formulário expirado não aparece na lista') do
  expect(page).not_to have_content('Avaliação Expirada')
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('vejo um botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Dado('que tentei abrir um formulário após seu deadline') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @expired_form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Expirada',
    start_date: 3.days.ago,
    end_date: 1.day.ago
  )
  
  @expired_form.classes << @class
end

Então('não consigo acessar o formulário') do
  expect(page).not_to have_selector('.questao')
end

Quando('acesso a página {string} e o servidor retorna erro') do |pagina|
  # Simula erro no servidor
  allow(Form).to receive(:for_user).and_raise(StandardError)
  visit avaliacoes_path
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('vejo um botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Então('nenhum formulário é exibido') do
  expect(page).not_to have_selector('.form-card')
end

Dado('que cliquei em um formulário para responder') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
end

Quando('a conexão com o servidor é perdida') do
  # Simula perda de conexão
  allow(page).to receive(:current_path).and_raise(Capybara::CapybaraError)
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o botão {string} é exibido') do |botao|
  expect(page).to have_button(botao)
end

Dado('que estava visualizando os detalhes de um formulário') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
  visit avaliacoes_path
  click_link @form.template_name
end

Quando('o administrador deleta o formulário') do
  @form.destroy
end

Quando('atualizo a página') do
  page.evaluate_script('location.reload()')
end

Dado('que estava preenchendo um formulário') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
  visit responder_form_path(@form)
  fill_in 'Questão 1', with: 'Minha resposta'
end

Quando('fecho a aba do navegador sem clicar em {string}') do |acao|
  # Simula fechamento sem salvar
  @saved = false
end

Quando('abro novamente o formulário') do
  visit responder_form_path(@form)
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o formulário começa vazio novamente') do
  expect(page).to have_field('Questão 1', with: '')
end

Dado('que estou preenchendo um formulário') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form.classes << @class
  visit responder_form_path(@form)
end

Quando('clico em {string} e o servidor retorna erro') do |acao|
  # Simula erro no servidor ao salvar
  allow(FormResponse).to receive(:create!).and_raise(StandardError)
  click_button acao
end

Então('permaneço na página de preenchimento') do
  expect(page).to have_current_path(responder_form_path(@form))
end

Então('meus dados continuam no formulário') do
  expect(page).to have_field('Questão 1', with: '')
end

Dado('que salvei 10 formulários como rascunho') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  10.times do |i|
    form = Form.create!(
      destiny_type: 'discente',
      template_name: "Avaliação #{i}",
      start_date: 1.day.ago,
      end_date: 1.day.from_now
    )
    form.classes << @class
    
    FormResponse.create!(
      form: form,
      user: @user,
      status: 'draft'
    )
  end
end

Quando('tento salvar outro formulário como rascunho') do
  @new_form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Extra',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @new_form.classes << @class
  
  visit responder_form_path(@new_form)
  click_button 'Salvar como Rascunho'
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('preciso deletar um rascunho anterior') do
  expect(page).to have_content('deletar')
end

Então('o formulário não é salvo') do
  expect(FormResponse.where(form: @new_form).count).to eq(0)
end

Dado('que sou um Dicente') do
  @user = User.create!(
    email:                 'dicente@gmail.com',
    matricula:             '190084013',
    password:              'senha',
    password_confirmation: 'senha',
    role:                  'discente'
  )
  
  visit login_path
  fill_in 'email', with: 'dicente@gmail.com'
  fill_in 'password', with: 'senha'
  click_button 'Entrar'
end

Quando('um formulário é enviado especificamente para Docentes') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @user.classes << @class
  
  @form_docente = Form.create!(
    destiny_type: 'docente',
    template_name: 'Avaliação para Docentes',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  
  @form_docente.classes << @class
end

Então('esse formulário não aparece na minha lista de não respondidos') do
  visit avaliacoes_path
  expect(page).not_to have_content('Avaliação para Docentes')
end

Então('não consigo acessá-lo mesmo tendo o link direto') do
  visit responder_form_path(@form_docente)
  expect(page).to have_content('Acesso não autorizado')
end
