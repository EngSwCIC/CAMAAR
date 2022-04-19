
Funcionalidade: Gráfico de aprovacão da classe
    Como um professor
    Eu quero ver gráfico gerado que mostre a porcentagem de aprovação/reprovação
    Junto aos dados de quantidade de alunos por menção obtida
    Para que eu possa analisar a performance da turma

Contexto:
    Dado que eu esteja logado como professor
    E eu esteja na pagina de filtragem de questoes

#HAPPY PATH
Cenário: O gráfico é gerado com sucesso
    Dado que os dados requisitados foram encontrados
    E os dados estão formatados corretamente
    Quando o professor escolhe uma turma específica
    Então a aplicação passa esses dados para o próximo passo
    E os resultados serão imprimidos na tela em forma de gráfico.

#SAD PATH
Cenário: A turma não existe

    Dado que não existem dados sobre a turma em questão
    Quando o professor escolhe a turma
    E os dados não são encontrados
    Então uma mensagem é impressa na tela
    E nenhum gráfico é gerado

#SAD PATH
Cenário: Os dados estão corrompidos ou mal formatados
    Dado que os dados estão fora do formato padrão
    Quando o professor escolhe a turma
    E os dados não encaixam no padrão
    E a função que gera o gráfico não consegue interpretar os dados
    Então uma mensagem de erro é impressa na tela
    E nenhum gráfico é gerado.