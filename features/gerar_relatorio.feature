# language: pt

Funcionalidade: Gerar relatório do administrador
  Como um Administrador
  Eu quero gerar relatórios com base nas respostas dos formulários
  A fim de analisar o feedback dos participantes sobre as turmas e professores

  Cenário: Gerar relatório consolidado com sucesso (Caminho Feliz)
    Dado que eu estou logado como "Administrador"
    E existem formulários respondidos para a "Turma de Engenharia de Software"
    Quando eu acesso a aba de "Relatórios"
    E seleciono a "Turma de Engenharia de Software"
    E clico em "Gerar Relatório"
    Então o sistema deve compilar os dados das respostas
    E apresentar um relatório visual na tela
    E disponibilizar um botão para "Exportar PDF"

  Cenário: Gerar relatório de uma turma sem respostas (Caminho Triste)
    Dado que eu estou logado como "Administrador"
    E a "Turma de Algoritmos" ainda não possui respostas enviadas
    Quando eu seleciono a "Turma de Algoritmos"
    E clico em "Gerar Relatório"
    Então o sistema não deve gerar o relatório
    E exibe a mensagem de erro "Dados insuficientes para gerar o relatório desta turma"
