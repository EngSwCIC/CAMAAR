#language: pt
Funcionalidade: Importar do SIGAA

Cenario: Tentar importar Turmas sem selecionar
Dado que estou na rota "/import"
E que eu busquei turmas
Quando clicar no botão "importButton"
Então eu devo ver uma notificação de "Selecione uma ou mais turmas para importar."

Cenario: Importar Turmas para o Banco de Dados
Dado que estou na rota "/import"
E que eu busquei turmas
#TODO: desmockar a req de busca de turmas
Quando eu digitar "engenharia" no campo de pesquisa da tabela de import
E selecionar a turma
E clicar no botão "importButton"
E esperar importar turmas
Então eu devo ver uma notificação de "Turmas selecionadas importadas com sucesso."
E eu devo ver "engenharia" na tabela de turmas cadastradas
