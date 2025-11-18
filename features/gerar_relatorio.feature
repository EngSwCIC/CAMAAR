# arquivo de especificação da issue "Gerar relatório do administrador" (Sprint 1)
@issue-101
Feature: Gerar relatório do administrador
  Como administrador
  Quero baixar um arquivo CSV com os resultados de um formulário
  A fim de avaliar o desempenho das turmas

  Cenário: Exportação de resultados concluída (feliz)
    Dado que o administrador acessa a página de resultados
    E seleciona um formulário com avaliações finalizadas
    Quando solicita a exportação em formato CSV
    Então o sistema deve gerar o arquivo contendo as respostas registradas

  Cenário: Exportação filtrada por turma (feliz)
    Dado que o administrador filtra os resultados por uma turma específica
    Quando solicita a exportação em CSV
    Então o sistema deve gerar o arquivo contendo apenas os dados daquela turma

  Cenário: Tentativa de exportação sem dados disponíveis (triste)
    Dado que o administrador tenta exportar um formulário sem respostas registradas
    Quando solicita o arquivo CSV
    Então o sistema deve impedir a exportação
    E manter o administrador na mesma página
