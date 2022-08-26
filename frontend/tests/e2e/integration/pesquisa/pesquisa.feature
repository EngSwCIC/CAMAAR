#language: pt
Funcionalidade: filtrar resultados da pesquisa

Cenario: pesquisa de questionarios com resultado
Dado que estou na rota "/#/student-subjects/"
Quando eu digitar "nome" no campo de pesquisa
E eu clicar no botão "FILTRO"
Então eu devo ver resultados com a palavra "nome"

@mockPesquisaSemResultado
Cenario: pesquisa de questionarios sem resultado
Dado que estou na rota "/#/student-subjects/"
Quando eu digitar "nome" no campo de pesquisa
E eu clicar no botão "FILTRO"
Então eu devo ver "pesquisa sem resultado"
