# language: pt

Funcionalidade: Exportação de resultados de formulários

  Como administrador
  Quero baixar um arquivo CSV contendo os resultados de um formulário
  Para avaliar o desempenho das turmas

  Cenário: Baixar arquivo CSV contendo resultados do formulário
    Dado que estou logado como administrador
    E entrei na página "Gerenciamento"
    E cliquei no botão "Resultados"
    Quando clicar em um dos formulários mostrados na grade
    Então um arquivo CSV deve ser gerado
    E uma mensagem de confirmação com botão "Baixar resultados" deve aparecer

  Cenário: Alertar que formulário está aberto ao tentar baixar relatório CSV
    Dado que estou logado como administrador
    E entrei na página "Gerenciamento"
    E cliquei no botão "Resultados"
    Quando clicar em um dos formulários mostrados na grade
    Então uma mensagem alertando "Formulário ainda está aberto! Tem certeza que deseja baixar o relatório?" deve aparecer

  Cenário: Ignorar alerta e baixar relatório CSV incompleto de formulário aberto
    Dado que apareceu uma mensagem alertando "Formulário ainda está aberto! Tem certeza que deseja baixar o relatório?" deve aparecer
    E clico em "Sim, baixar relatório incompleto"
    Então um arquivo CSV deve ser gerado
    E uma mensagem de confirmação com botão "Baixar resultados" deve aparecer
