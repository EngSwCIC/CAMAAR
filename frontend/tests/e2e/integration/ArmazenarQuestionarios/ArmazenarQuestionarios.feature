#language: pt
Funcionalidade: Tornar os questionários respondidos anônimos
  Como um aluno
  Eu quero que os questionários respondidos sejam anônimos
  Para que eu possa ter mais liberdade para responder os questionários

  Como um professor
  Eu quero que os questionários não possam ser respondidos mais de uma vez
  Para que eu possa ter mais confiança nos resultados

  Contexto:
    Dado que eu esteja logado como aluno no CAMAAR
    E eu esteja na página de responder o questionário

  Cenário: Consigo responder o questionário pela primeira vez (feliz)
    E que eu já tenha completado o questionário
    Então eu consigo enviar o questionário

  Cenário:  Tento responder o questionário pela segunda vez (triste)
    E que eu já tenha respondido o questionário uma vez
    E que eu já tenha completado o questionário
    Então o questionário não me permite responder novamente
    