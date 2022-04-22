Funcionalidade: Extrair do SIGAA

Cenario: Buscar Turmas para importação
Dado que estou na tela de importar Turmas
Se eu clicar no botão de buscar Turmas
Então eu devo ver na tabela um ou mais turmas

Cenario: Buscar Turmas para importação sem resultado
Dado que estou na tela de importar Turmas
Se eu clicar no botão de buscar Turmas
E não retornar nenhuma turma na tabela
Então eu devo ver uma notificação de "Falha ao buscar turmas."
