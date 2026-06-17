# frozen_string_literal: true

# Step definitions for: Criar formulário baseado em template

Dado('que eu estou logado como administrador') do
  # TODO: Implementar autenticação como administrador
  # administrador = Administrador.create!(
  #   nome: "Admin",
  #   email: "admin@ufpe.br",
  #   matricula: "admin123",
  #   departamento: Departamento.first
  # )
  # administrador.enviar_email_definicao_senha!
  # visit login_path
  # fill_in 'login', with: administrador.email
  # fill_in 'senha', with: 'senha_temporaria'
  # click_button 'Entrar'
end

Dado('que existe um template chamado {string} com as seguintes perguntas:') do |nome_template, table|
  # table is a Cucumber::MultilineArgument::DataTable
  # | Pergunta                       | Tipo            | Opções                    |
  # | Como você avalia o professor?  | Múltipla Escolha | Ótimo, Bom, Regular, Ruim |
  # | Qual seu nível de satisfação?  | Escala          | 1, 2, 3, 4, 5             |
  # | Deixe seu comentário          | Texto           |                           |
  #
  # TODO: Implementar criação de template com elementos e campos
  # @template = Template.create!(nome: nome_template)
  #
  # table.hashes.each do |row|
  #   elemento = @template.elementos.create!(enunciado: row['Pergunta'], ordem: @template.elementos.count + 1)
  #
  #   case row['Tipo']
  #   when 'Múltipla Escolha', 'Escala'
  #     row['Opções'].split(', ').each_with_index do |opcao, index|
  #       elemento.campos.create!(tipo_elemento: row['Tipo'], enunciado: opcao, ordem: index + 1)
  #     end
  #   when 'Texto'
  #     elemento.campos.create!(tipo_elemento: 'Texto', enunciado: '', ordem: 1)
  #   end
  # end
end

Dado('que existem as seguintes turmas no semestre {string}:') do |semestre, table|
  # table is a Cucumber::MultilineArgument::DataTable
  # | Código | Disciplina  | Turma |
  # | TEC001 | Matemática  | A     |
  # | TEC002 | Português   | B     |
  # | TEC003 | História    | A     |
  #
  # TODO: Implementar criação de turmas
  # table.hashes.each do |row|
  #   departamento = Departamento.find_or_create_by!(nome: 'Departamento Padrão', codigo: 'DEP01')
  #   disciplina = Disciplina.find_or_create_by!(
  #     codigo: row['Código'],
  #     nome: row['Disciplina'],
  #     departamento: departamento
  #   )
  #   Turma.find_or_create_by!(
  #     disciplina: disciplina,
  #     numero_da_turma: row['Turma'],
  #     semestre: semestre,
  #     horario: 'Seg 08:00-10:00'
  #   )
  # end
  # @turmas_disponiveis = Turma.where(semestre: semestre)
end

Quando('eu acesso a página de criação de formulário a partir de template') do
  # TODO: Implementar rota para criação de formulário a partir de template
  # visit new_formulario_from_template_path
end

Quando('eu seleciono o template {string}') do |nome_template|
  # TODO: Implementar seleção de template na interface
  # select nome_template, from: 'template_id'
end

Quando('eu não seleciono nenhum template') do
  # TODO: Garantir que nenhum template está selecionado
end

Quando('eu seleciono as turmas {string}') do |turmas_texto|
  # TODO: Implementar seleção de turmas
  # Exemplo de turmas_texto: "TEC001 - Matemática - A"
  # turmas_texto.split(' e ').each do |turma_info|
  #   partes = turma_info.split(' - ')
  #   codigo = partes[0]
  #   nome_disciplina = partes[1]
  #   numero_turma = partes[2]
  #
  #   disciplina = Disciplina.find_by!(codigo: codigo, nome: nome_disciplina)
  #   turma = Turma.find_by!(disciplina: disciplina, numero_da_turma: numero_turma)
  #   check "turma_ids_#{turma.id}"
  # end
end

Quando('eu não seleciono nenhuma turma') do
  # TODO: Garantir que nenhuma turma está selecionada
end

Quando('eu clico em {string}') do |nome_botao|
  click_button nome_botao
end

Então('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o formulário deve conter as perguntas do template {string}') do |nome_template|
  # TODO: Verificar se o formulário foi criado com os elementos copiados do template
  # template = Template.find_by!(nome: nome_template)
  # formulario = Formulario.last
  # expect(formulario.elemento_forms.count).to eq(template.elementos.count)
  # formulario.elemento_forms.each_with_index do |ef, i|
  #   expect(ef.enunciado).to eq(template.elementos[i].enunciado)
  # end
end

Então('o formulário deve estar associado à turma {string}') do |nome_turma_info|
  # TODO: Verificar associação com a turma correta
  # partes = nome_turma_info.split(' - ')
  # nome_disciplina = partes[0]
  # numero_turma = partes[1]
  # disciplina = Disciplina.find_by!(nome: nome_disciplina)
  # turma = Turma.find_by!(disciplina: disciplina, numero_da_turma: numero_turma)
  # expect(Formulario.last.turma).to eq(turma)
end

Então('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('deve existir um formulário para a turma {string}') do |nome_turma_info|
  # TODO: Verificar existência do formulário para a turma
  # partes = nome_turma_info.split(' - ')
  # nome_disciplina = partes[0]
  # numero_turma = partes[1]
  # disciplina = Disciplina.find_by!(nome: nome_disciplina)
  # turma = Turma.find_by!(disciplina: disciplina, numero_da_turma: numero_turma)
  # expect(Formulario.exists?(turma: turma)).to be true
end

Então('cada formulário deve conter as perguntas do template {string}') do |nome_template|
  # template = Template.find_by!(nome: nome_template)
  # Formulario.all.each do |formulario|
  #   expect(formulario.elemento_forms.count).to eq(template.elementos.count)
  # end
end

Então('eu devo ver a lista de templates disponíveis') do
  # TODO: Verificar se os templates são exibidos
  # Template.all.each do |template|
  #   expect(page).to have_content(template.nome)
  # end
end

Então('eu devo ver a lista de turmas do semestre {string} disponíveis') do |semestre|
  # TODO: Verificar se as turmas do semestre são exibidas
  # Turma.where(semestre: semestre).each do |turma|
  #   expect(page).to have_content(turma.disciplina.nome)
  # end
end
