#language: pt
Funcionalidade: Extrair do SIGAA

Cenario: Buscar Turmas para importação
Dado que estou na rota "/import"
E eu clicar no botão "searchButton"
Então eu devo ver na tabela uma ou mais turmas

@mockTurmasVazias
Cenario: Buscar Turmas para importação sem resultado
Dado que estou na rota "/import"
E eu clicar no botão "searchButton"
E não retornar nenhuma turma na tabela
Então eu devo ver uma notificação de "Erro ao buscar turmas"
