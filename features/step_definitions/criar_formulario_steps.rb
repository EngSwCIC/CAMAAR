# frozen_string_literal: true

Dado('que eu estou logado como professor') do
  departamento = Departamento.find_or_create_by!(nome: 'Departamento de Teste', codigo: 'TST')

  @admin = Administrador.find_or_create_by!(email: 'professor@teste.com') do |a|
    a.nome = 'Professor Teste'
    a.matricula = 'prof001'
    a.senha = 'Senha123'
    a.senha_confirmation = 'Senha123'
    a.departamento = departamento
  end

  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  allow_any_instance_of(AdminController).to receive(:set_admin) do |controller|
    controller.instance_variable_set(:@admin, @admin)
  end
end

Dado('eu estou na página de criação de formulários') do
  departamento = Departamento.find_or_create_by!(nome: 'Departamento de Teste', codigo: 'TST')

  disciplina = Disciplina.find_or_create_by!(codigo: 'CIC0001') do |d|
    d.nome = 'Engenharia de Software'
    d.departamento = departamento
  end

  @turma = Turma.find_or_create_by!(
    disciplina: disciplina,
    numero_da_turma: '01',
    semestre: '2026.1'
  ) do |t|
    t.horario = '235M12'
  end

  @template = Template.find_or_create_by!(nome: 'Avaliação Padrão', usuario_id: @admin.id) do |t|
    elemento = t.elementos.build(enunciado: 'Como você avalia o professor?', ordem: 1)
    elemento.campos.build(
      tipo_elemento: 'Múltipla Escolha',
      enunciado: 'Ótimo',
      ordem: 1
    )
    elemento.campos.build(
      tipo_elemento: 'Múltipla Escolha',
      enunciado: 'Bom',
      ordem: 2
    )
    elemento.campos.build(
      tipo_elemento: 'Múltipla Escolha',
      enunciado: 'Regular',
      ordem: 3
    )
    elemento.campos.build(
      tipo_elemento: 'Múltipla Escolha',
      enunciado: 'Ruim',
      ordem: 4
    )
  end

  visit admin_enviar_formularios_path(@admin)
end

Quando('eu escolho um template para o formulário') do
  select @template.nome, from: 'template_id'
end

Quando('escolho um template para o formulário') do
  select @template.nome, from: 'template_id'
end

Quando('escolho uma turma para enviar o formulário') do
  check "turma_ids_#{@turma.id}"
end

Quando('envio o formulário') do
  click_button 'Criar Formulário'
end

Quando('eu não escolho um template para o formulário') do
  # deliberately do nothing - leave template select at default blank option
end

Quando('eu não escolho uma turma para enviar o formulário') do
  # deliberately do nothing - leave no turma checkboxes checked
end

Então('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o formulário deve estar disponível para os alunos da turma selecionada') do
  formulario = Formulario.find_by(turma: @turma)
  expect(formulario).to be_present
  expect(formulario.titulo).to eq("#{@turma.disciplina.nome} - #{@turma.semestre}")

  elemento_forms_count = formulario.elemento_forms.count
  template_elementos_count = @template.elementos.count
  expect(elemento_forms_count).to eq(template_elementos_count)
end
