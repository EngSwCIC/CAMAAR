#language: pt
Funcionalidade: Gerar resumo gráfico das avaliações de todas as turmas do semestre atual
Eu como administrador
Quero gerar um resumo gráfico das avaliações de todas as turmas
A fim de ter uma maneira fácil de comparar o desempenho das turmas do CIC de semestres diferentes

Contexto:
	Dado que eu esteja logado como administrador no CAMAAR
	E eu esteja na página de avaliações das turmas
	E que exista um botão "Gerar gráfico"

# Sad path	
Cenario: O Administrador tenta gerar o gráfico, mas não há nenhuma pesquisa registrada para o semestre
	Dado que não há pesquisas registradas nesse semestre no sistema
	Quando eu clicar no botão "Gerar gráfico"
	Então eu deveria ver uma mensagem na tela dizendo "Nenhuma pesquisa registrada"

# Happy path
Cenario: O Administrador gera um gráfico que resume as avaliações das turmas
	Dado que a página de avaliações apresente uma ou mais turmas
	Quando o administrador clicar no botão "Gerar gráfico"
	Então deve ser criado um gráfico com as informações das avaliações
