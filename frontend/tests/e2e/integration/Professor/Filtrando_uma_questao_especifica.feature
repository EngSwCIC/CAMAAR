Feature: Filtrando uma questão específica.
    Como um professor
    Eu quero ver os dados de uma certa questão de uma avaliação
    Para que eu possa analisar a perfomance de minha turma.

#CAMINHO FELIZ
Cenário: Uma questão é escolhida com dados bons.
    Dado que os dados da avaliação escolhida foram encontrados
    E todos os dados são bons para uso
    E que o usário está logado como professor
    Quando o professor escolher uma questão específica 
    Então os resultados da filtragem devem ser mostrados na tela do professor
    E a aplicação deve passar tais dados para o próximo passo (Geração de gráficos).

#CAMINHO TRISTE
Cenário: A questão escolhida não existe.
    Dado que não há dados sobre tal questão
    E que o usário está logado como professor
    Quando o professor escolher essa questão  
    E nenhum dado for encontrados
    Então uma mensagem de alerta deve ser mostrada na tela do professor
    E os resultados da filtragem não serão mostrados em sua tela.

#CAMINHO TRISTE
Cenário: Os dados foram corrompidos.
    Dado que há dados corrompidos na questão
    E que o usário está logado como professor
    Quando o professor escolher essa questão
    E os dados não forem encontrados
    E o aplicativo não é capaz de filtrar os valores
    Então uma mensagem de alerta aparecerá na tela do professor.
    E os resultados filtragem não serão mostrados em sua tela.