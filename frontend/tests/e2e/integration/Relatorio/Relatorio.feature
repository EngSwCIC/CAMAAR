#language: pt
Funcionalidade: Importar do SIGAA

Cenario: Gerar relatório com intervalo de semestre e uma matéria existente
Dado que estou na tela de gerar relatório e logado como administrador
E que eu selecionei um período
Se eu selecionar uma turma
E clicar no botão de "Gerar relatório"
Então os resultados devem ser retornados, deve-se fazer um gráfico de histograma para cada item apresentado. A resposta de cada período deve ser representado com uma cor distinta

Cenario: Gerar relatório vazio com intervalo de semestre e uma matéria selecionado
Dado que estou na tela de gerar relatório e logado como administrador
E que eu selecionei um período 
Se eu selecionar uma turma
E clicar no botão de "Gerar relatório" sem obter resultados
Então devo ver uma notificação de "Falha ao gerar relatório"
Caso turma ou período ou ambos não tenham sido selecionados, deve-se retornar erro indicando qual a seleção não foi feita