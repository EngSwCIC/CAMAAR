Feature: Gerar arquivo .CSV
    Como um professor
    Eu quero poder gerar um arquivo .csv
    Para que eu possa utilizar esses dados em outra plataforma

#HAPPY PATH
Scenario: O gráfico é gerado com sucesso
    Dado que os dados requisitados foram encontrados
    E os dados estão formatados corretamente
    Quando o professor escolhe uma turma específica
    Então a aplicação passa esses dados para o próximo passo
    E os dados são compilados em um arquivo .csv
    E o arquivo .csv é baixado do navegador.

#SAD PATH
Scenario: A turma não existe

    Dado que não existem dados sobre a turma em questão
    Quando o professor escolhe a turma
    E os dados não são encontrados
    Então uma mensagem de erro é impressa na tela
    E nenhum arquivo é gerado
    E nenhum arquivo é baixado.

#SAD PATH
Scenario: Os dados estão corrompidos ou mal formatados
    Dado que os dados estão fora do formato padrão
    Quando o professor escolhe a turma 
    E os dados não encaixam no padrão
    E a função que gera o arquivo .csv não consegue interpretar os dados
    Então uma mensagem de erro é impressa na tela
    E nenhum arquivo é gerado
    E nenhum arquivo é baixado.