# language: pt

Funcionalidade: Visualização de formulários para responder
  Como um Participante
  Eu quero visualizar os formulários de avaliação pendentes
  A fim de saber quais avaliações eu preciso preencher

  Cenário: Visualizar formulários pendentes com sucesso (Caminho Feliz)
    Dado que eu estou logado como "Participante"
    E existem formulários pendentes atribuídos a mim
    Quando eu acesso a página de "Meus Formulários"
    Então eu devo ver uma lista com os formulários não respondidos
    E cada item da lista deve ter um botão "Responder"

  Cenário: Sem formulários pendentes (Caminho Triste)
    Dado que eu estou logado como "Participante"
    E não existem formulários pendentes para mim
    Quando eu acesso a página de "Meus Formulários"
    Então a lista de formulários deve estar vazia
    E o sistema exibe a mensagem "Você não possui formulários pendentes"
