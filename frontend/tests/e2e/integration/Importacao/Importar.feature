#language: pt
Funcionalidade: Importar do SIGAA

Cenario: Importar Turmas para o Banco de Dados
Dado que estou na tela de importar Turmas
E que eu busquei turmas
Se eu selecionar uma turma
E clicar no botão de "Importar"
Então eu devo ver na tabela de turmas importadas a turma selecionada
E devo ver uma notificação de confirmação

Cenario: Tentar importar Turmas sem selecionar
Dado que estou na tela de importar Turmas
E que eu busquei turmas
Se eu não selecionar uma turma
E clicar no botão de "Importar"
Então devo ver uma notificação de "Selecione no mínimo uma turma"
