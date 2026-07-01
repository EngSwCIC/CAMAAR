Dado('que eu estou logado como discente') do
  depto = Departamento.find_or_create_by!(nome: 'Departamento', codigo: 'TST')
  curso = Curso.find_or_create_by!(codigo: 'TST') do |c|
    c.nome = 'Curso Teste'
    c.departamento = depto
  end

  @discente = Discente.find_or_create_by!(matricula: '2024001') do |u|
    u.nome = 'Discente Teste'
    u.email = 'discente@teste.com'
    u.senha = 'Senha123'
    u.senha_confirmation = 'Senha123'
    u.curso = curso
  end

  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@discente)
end

Dado('existe um formulário ativo para minha turma') do
  depto = Departamento.find_or_create_by!(nome: 'Departamento', codigo: 'TST')
  disciplina = Disciplina.find_or_create_by!(codigo: 'CIC0001') do |d|
    d.nome = 'Engenharia de Software'
    d.departamento = depto
  end

  turma = Turma.find_or_create_by!(
    disciplina: disciplina,
    numero_da_turma: '01',
    semestre: '2026.1'
  ) do |t|
    t.horario = '235M12'
  end

  @discente.turmas << turma unless @discente.turmas.include?(turma)

  @formulario = Formulario.find_or_create_by!(turma: turma) do |f|
    f.titulo = 'Avaliação de Turma 2026.1'
  end

  elemento = @formulario.elemento_forms.find_or_create_by!(ordem: 1) do |ef|
    ef.enunciado = 'Como você avalia o professor?'
    ef.tipo = 'Múltipla Escolha'
  end

  elemento.campo_forms.find_or_create_by!(ordem: 1) { |c| c.enunciado = 'Ótimo' }
  elemento.campo_forms.find_or_create_by!(ordem: 2) { |c| c.enunciado = 'Bom' }
  elemento.campo_forms.find_or_create_by!(ordem: 3) { |c| c.enunciado = 'Regular' }
  elemento.campo_forms.find_or_create_by!(ordem: 4) { |c| c.enunciado = 'Ruim' }

  elemento2 = @formulario.elemento_forms.find_or_create_by!(ordem: 2) do |ef|
    ef.enunciado = 'Comente sobre a didática'
    ef.tipo = 'Texto'
  end

  elemento2.campo_forms.find_or_create_by!(ordem: 1)
end

Dado('eu estou na página de formulários disponíveis') do
  visit usuarios_avaliacoes_path(@discente)
end

Quando('eu clico para responder o formulário') do
  click_link @formulario.turma.disciplina.nome
end

Então('eu devo visualizar os detalhes e perguntas pertinentes a ele') do
  @formulario.elemento_forms.each do |ef|
    expect(page).to have_content(ef.enunciado)
  end
end

Quando('eu respondo todos os campos do formulário') do
  @formulario.elemento_forms.order(:ordem).each do |ef|
    if ef.tipo == 'Texto'
      fill_in "respostas[#{ef.id}]", with: 'Uma resposta qualquer'
    else
      primeiro_campo = ef.campo_forms.order(:ordem).first
      find("input[type='radio'][name='respostas[#{ef.id}]'][value='#{primeiro_campo.id}']").click
    end
  end
end

Quando('eu envio o fomulário') do
  click_button type: 'submit'
end

Quando('eu envio o formulário') do
  click_button type: 'submit'
end

# Então('eu devo ver a mensagem {string}') do |mensagem|
#  expect(page).to have_content(mensagem)
# end

Então('a resposta deve ser registrada no sistema') do
  expect(RespostaForm.exists?(formulario: @formulario, usuario: @discente)).to be true
end

Então('eu não devo mais ser capaz de responder ao mesmo formulário') do
  click_link @formulario.turma.disciplina.nome
  expect(page).to have_content("Você já respondeu este formulário.")
end

Quando('eu deixo uma pergunta obrigatória em branco') do
  campo_texto = @formulario.elemento_forms.find_by(tipo: 'Texto')
  fill_in "respostas[#{campo_texto.id}]", with: ''
end
