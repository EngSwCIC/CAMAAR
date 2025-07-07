# language: pt

Funcionalidade: Visualização do resultado de formulários

  Como Administrador
  Quero visualizar os formulários que foram criados
  Para poder gerar relatório a partir de respostas coletadas

  Cenário: Listando formulários criados para baixar os resultados
    Dado que estou logado como administrador
    E existem formulários previamente criados no sistema
    E estou na página "Gerenciamento"
    Quando clicar em "Resultados"
    Então devo ver uma grade com todos os formulários disponíveis

  Cenário: Zero formulários na página de resultados
    Dado que estou logado como administrador
    E estou na página "Gerenciamento"
    Quando clicar em "Resultados"
    Então o botão deve estar desabilitado e nada deve acontecer
