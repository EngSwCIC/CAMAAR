#language: pt

Funcionalidade: Gerar graficos para questao filtrada
    Como um Professor
    Eu quero gerar um grafico para uma questao filtrada
    A fim de visualizar as opinioes dos alunos sobre a questao

Contexto:
    Dado que eu esteja logado como professor
    E eu esteja na pagina de filtragem de questoes

# Caminho feliz
Cenario: Gerar grafico
    Dado que eu esteja na pagina de filtragem de questoes
    E eu seleciono uma questao
    Entao a aplicacao deve procurar no banco de dados pelos dados da questao     
    Entao a aplicacao deve mandar os dados para o gerador de grafico
    Entao eu deveria ver um grafico ser gerado abaixo do campo de selecao
    E o grafico deveria ter os dados da questao selecionada

# Caminho triste
Cenario: Erro na consulta ao banco de dados
    Dado que eu esteja na pagina de filtragem de questoes
    E eu seleciono uma questao
    E a aplicacao falha ao tentar consultar o banco de dados
    Entao a aplicacao deveria mostrar uma mensagem de erro ao usuario
    E a aplicacao nao deveria gerar um grafico

# Caminho triste
Cenario: Dados incompativeis
    Dado que eu esteja na pagina de filtragem de questoes
    E eu seleciono uma questao
    Entao a aplicacao deve procurar no banco de dados pelos dados da questao
    Entao a aplicacao deve mandar os dados para o gerador de grafico
    Entao o gerador de graficos deveria falhar na geração do grafico
    Entao a aplicacao deveria mostrar uma mensagem de erro ao usuario
    E o grafico nao deveria ser gerado