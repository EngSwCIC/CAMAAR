# encoding: utf-8
#
# Steps específicos da visualização de resumo de resultados.
# Os steps de contexto (turma com/sem respostas, navegação, card da turma,
# mensagens de erro/aviso) já existem em gerar_relatorio_steps.rb, shared_steps.rb
# e navigation_steps.rb e são reaproveitados aqui.

Então('vejo o nome do template do formulário') do
  expect(page).to have_content(@template.name)
end

Então('vejo a quantidade total de respostas recebidas') do
  total = FormResponse.where(turma: @turma).count
  expect(page).to have_content("Total de respostas recebidas: #{total}")
end

Então('vejo um resumo para cada questão do formulário') do
  @template.questions.each do |questao|
    expect(page).to have_selector('.questao-resumo', text: questao.text)
  end
end

Então('a questão do tipo {string} exibe a quantidade de respostas recebidas para cada opção') do |tipo|
  questao = @template.questions.find_by(kind: 'radio')
  within(".questao-resumo[data-tipo='radio']", text: questao.text) do
    expect(page).to have_selector('.opcoes-resumo li')
  end
end

Então('a questão do tipo {string} exibe a lista com todas as respostas recebidas') do |tipo|
  questao = @template.questions.find_by(kind: 'text')
  within(".questao-resumo[data-tipo='text']", text: questao.text) do
    expect(page).to have_selector('.respostas-texto li')
  end
end

Então('não vejo nenhum resumo de questão') do
  expect(page).not_to have_selector('.questao-resumo')
end
