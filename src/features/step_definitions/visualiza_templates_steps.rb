Dado('que estou logado') do
  pending
end

Dado('estou na página {string}') do |pagina|
  pending
end

Dado(
  'existe um template criado com o campo nome_da_matéria igual a {string}, ' \
  'e o campo semestre igual a {string}, ' \
  'e o campo professor igual a {string}'
) do |nome, semestre, professor|
  pending
end

Então('devo ver um cartão da disciplina contendo: {string}, {string}, {string}') do |nome, semestre, professor|
  pending
end

Dado('que não existe nenhum template criado') do
  pending
end

Então('devo visualizar a mensagem {string}') do |mensagem|
  pending
end