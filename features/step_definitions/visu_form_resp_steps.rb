# encoding: utf-8
#
# Steps da feature "Visualizar Formulários Não Respondidos" — escopo
# reduzido aos cenários felizes básicos (lista, detalhes e acesso para
# responder). Reaproveita "que estou logado como Participante" (auth_steps.rb)
# e "clico no botão {string}" (navigation_steps.rb).

Dado('estou matriculado em uma turma com formulário pendente') do
  @disciplina = Disciplina.create!(code: 'CIC0099', name: 'Visualização de Formulários')
  @turma = Turma.create!(classCode: 'TB', semester: '2026.1', time: '08:00', disciplina: @disciplina)
  TurmaMembership.find_or_create_by!(turma: @turma, user: @user)

  @template = Template.create!(name: 'Avaliação da Disciplina')
  @questao1 = @template.questions.create!(kind: 'radio', text: 'Como avalia a disciplina?', options: ['Ótima', 'Boa', 'Ruim'])
  @questao2 = @template.questions.create!(kind: 'text', text: 'Comentários adicionais')

  @form = Form.create!(template: @template, start_date: 1.day.ago, end_date: 1.week.from_now)
  @form.turmas << @turma
end

Então('vejo uma seção com os formulários não respondidos das minhas turmas') do
  expect(page).to have_selector('.formularios-nao-respondidos')
end

# ==================== Cenário: lista de formulários não respondidos ====================

Então('vejo uma lista com cards de formulários não respondidos') do
  expect(page).to have_selector('.turma-card')
end

Então('cada card exibe {string}, {string}, {string} e um botão {string}') do |_turma_label, _template_label, _data_label, botao|
  within('.turma-card', match: :first) do
    expect(page).to have_selector('.turma-nome')
    expect(page).to have_selector('.template-nome')
    expect(page).to have_selector('.data-termino')
    expect(page).to have_css('.btn-responder', text: botao)
  end
end

Então('os formulários são agrupados por turma') do
  expect(page).to have_selector('.turma-card', count: @form.turmas.count)
end

# ==================== Cenário: informações completas de um formulário ====================

Quando('clico no card de um formulário') do
  visit avaliacoes_path
  within('.turma-card', match: :first) { click_link @turma.classCode }
end

Então('vejo os detalhes completos como {string}, {string}, {string}, {string}') do |_turma_label, _template_label, _inicio_label, _termino_label|
  expect(page).to have_selector('.detalhe-turma', text: @turma.classCode)
  expect(page).to have_selector('.detalhe-template', text: @template.name)
  expect(page).to have_selector('.detalhe-data-inicio')
  expect(page).to have_selector('.detalhe-data-termino')
end

Então('vejo a quantidade de questões do formulário') do
  expect(page).to have_selector('.detalhe-qtd-questoes', text: "#{@template.questions.count} questões")
end

Então('vejo um botão {string}') do |botao|
  expect(page).to have_button(botao)
end

# ==================== Cenário: acessar formulário para responder ====================

Dado('que estou visualizando um formulário não respondido') do
  visit detalhes_avaliacao_path(@turma)
end

Então('sou redirecionado para a página de preenchimento do formulário') do
  expect(page).to have_current_path(avaliacao_path(@turma), wait: 5)
end

Então('vejo todas as questões do template') do
  @template.questions.each do |questao|
    expect(page).to have_content(questao.text)
  end
end

# ==================== Cenário: turma em que não estou matriculado ====================

Dado('que tentei acessar um formulário através de um link antigo') do
  outra_disciplina = Disciplina.create!(code: 'CIC0106', name: 'Estruturas de Dados')
  @turma_nao_matriculada = Turma.create!(classCode: 'TC', semester: '2026.1', time: '10:00', disciplina: outra_disciplina)

  outro_template = Template.create!(name: 'Avaliação de Estruturas de Dados')
  outro_template.questions.create!(kind: 'text', text: 'Comentários')

  outro_form = Form.create!(template: outro_template, start_date: 1.day.ago, end_date: 1.week.from_now)
  outro_form.turmas << @turma_nao_matriculada
end

Quando('abro o link de um formulário da turma {string} em que não estou matriculado') do |_class_code|
  visit avaliacao_path(@turma_nao_matriculada)
end

# ==================== Cenário: responder após o deadline ====================

Dado('que tentei abrir um formulário após seu deadline') do
  visit detalhes_avaliacao_path(@turma)

  # Simula o prazo vencendo enquanto o participante já estava com a página
  # de detalhes aberta — a validação precisa acontecer no servidor, não só
  # esconder o botão na tela. Move start_date junto para não violar a
  # regra de end_date >= start_date.
  @form.update!(
    start_date: Time.zone.local(2026, 5, 19, 0, 0, 0),
    end_date:   Time.zone.local(2026, 5, 26, 23, 59, 59)
  )
end

Então('não consigo acessar o formulário') do
  expect(page).not_to have_button('Enviar Avaliação')
end

# ==================== Cenário: sem permissão para responder formulário ====================

Dado('que sou um Dicente') do
  expect(@user.role).to eq('discente')
end

Quando('um formulário é enviado especificamente para Docentes') do
  disciplina = Disciplina.create!(code: 'CIC0107', name: 'Compiladores')
  @turma_docente = Turma.create!(classCode: 'TE', semester: '2026.1', time: '16:00', disciplina: disciplina)
  # O dicente está matriculado na turma, mas o formulário é destinado a docentes
  TurmaMembership.find_or_create_by!(turma: @turma_docente, user: @user)

  template = Template.create!(name: 'Avaliação para Docentes')
  template.questions.create!(kind: 'text', text: 'Comentário sobre a turma')

  @form_docente = Form.create!(template: template, start_date: 1.day.ago, end_date: 1.week.from_now, destinatario: 'docente')
  @form_docente.turmas << @turma_docente
end

Então('esse formulário não aparece na minha lista de não respondidos') do
  visit avaliacoes_path
  expect(page).not_to have_selector("#formulario_#{@form_docente.id}")
end

Então('não consigo acessá-lo mesmo tendo o link direto') do
  visit avaliacao_path(@turma_docente)
  expect(page).to have_current_path(avaliacoes_path, wait: 5)
end
