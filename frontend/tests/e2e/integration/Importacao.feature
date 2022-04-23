#language: pt
Funcionalidade: Importar do SIGAA

Cenario: Importar Turmas para o Banco de Dados
Dado que estou na rota "/import"
E que eu busquei turmas
Quando eu digitar "banco" no campo de pesquisa da tabela de import
E selecionar a turma
E clicar no botão "Importar"
Então eu devo ver uma notificação de "Turmas importadas com sucesso."

Cenario: Tentar importar Turmas sem selecionar
Dado que estou na rota "/import"
E que eu busquei turmas
E eu não selecionar uma turma
Quando clicar no botão de "Importar"
Então devo ver uma notificação de "Selecione no mínimo uma turma"
