# language: pt
Funcionalidade: Responder formulário

  Eu como participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

  # FELIZ
  Cenário: Responder Questionário com Sucesso
    Dado que estou logado na plataforma e matriculado em uma turma
    Quando acesso a página de avaliações e seleciono o questionário da minha turma
    Então preencho todas as perguntas do questionário
    E submeto minhas respostas
    Então recebo uma confirmação de que minha avaliação foi submetida com sucesso

  # TRISTE
  Cenário: Questionário Incompleto
    Dado que estou logado na plataforma e matriculado em uma turma
    Quando acesso a página de avaliações e seleciono o questionário da minha turma
    Então preencho parcialmente o questionário e tento submetê-lo
    Então recebo uma mensagem de erro indicando que todas as perguntas devem ser respondidas antes de submeter

  # TRISTE
  Cenário: Não Matriculado em Nenhuma Turma
    Dado que estou logado na plataforma, mas não estou matriculado em nenhuma turma
    Quando acesso a página de avaliações
    Então recebo uma mensagem informando que não estou matriculado em nenhuma turma e, portanto, não há questionários disponíveis para responder

  # FELIZ
  Cenário: Salvar Respostas Parcialmente
    Dado que estou logado na plataforma e matriculado em uma turma
    Quando acesso a página de avaliações e seleciono o questionário da minha turma
    Então preencho parte das perguntas e salvo minhas respostas sem submeter
    E recebo uma confirmação de que minhas respostas foram salvas e posso continuar mais tarde

  # TRISTE
  Cenário: Erro ao Submeter Questionário
    Dado que estou logado na plataforma e matriculado em uma turma
    Quando preencho todas as perguntas do questionário e tento submetê-lo
    Então ocorre um erro técnico ao tentar submeter minhas respostas
    E recebo uma mensagem de erro informando que houve um problema ao submeter o questionário e sou orientado a tentar novamente mais tarde
