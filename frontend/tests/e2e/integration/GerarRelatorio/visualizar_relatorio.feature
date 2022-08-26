#languague pt

Funcionalidade: Visualizar avaliação
Eu como aluno
Quero saber sobre as avaliações das minhas turmas
A fim de avaliar o desempenho das turmas em que estou matriculado

Contexto:
    Dado que estou logado
    E estou na página do aluno
    E gero um relatório

Cenario: relatório vem com todas as informações
    Dada que minha avaliação foi lançada
    Quando eu gerar o relatório
    Então as informaçoes da minha avaliação aparecerão.

Cenario: relatório não vem com todas as informações
    Dada que minha avaliação não foi lançada
    Quando eu gerar o relatório
    Então será apresentada a mensagem "Avaliação não encontrada".