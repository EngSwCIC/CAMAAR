#language: pt
Funcionalidade: Importar do SIGAA

Cenario: Gerar relatório com intervalo de semestre e uma matéria existente
Dado que estou na tela de gerar relatório
E que eu selecionei um período
Se eu selecionar uma turma
E clicar no botão de "Gerar relatório"
Então eu devo ver uma página com dados sobre os parâmetro selecionados
E devo gerar um relatório final

Cenario: Gerar relatório vazio com intervalo de semestre e uma matéria selecionado
Dado que estou na tela de gerar relatório
E que eu selecionei um período 
Se eu selecionar uma turma
E clicar no botão de "Gerar relatório" sem obter resultados
Então devo ver uma notificação de "Falha ao gerar relatório"