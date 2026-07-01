# language: pt

Funcionalidade: Visualização de formulários para responder
  Como discente
  Quero visualizar a lista de formulários não respondidos das turmas em que estou matriculado
  A fim de saber quais avaliações eu preciso responder no semestre letivo

  Cenário: [Feliz] Visualizar a lista de formulários disponíveis para resposta
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    E eu estou matriculado na turma "CIC0097 - BANCOS DE DADOS"
    E existe um formulário aberto e não respondido para esta turma
    Quando eu acesso a aba de "Formulários Pendentes"
    Então eu devo ver o formulário da turma "CIC0097 - BANCOS DE DADOS" na lista

  Cenário: [Triste] Tentar visualizar formulários não estando matriculado em disciplinas
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    E o sistema registra que eu não possuo matrícula ativa no semestre atual
    Quando eu acesso a aba de "Formulários Pendentes"
    Então devo ver a mensagem "Nenhum formulário pendente. Você está em dia!"

  Cenário: [Triste] Não visualizar formulários quando não há matrícula ativa
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    E eu não estou matriculado na turma "CIC0105 - ENGENHARIA DE SOFTWARE"
    E existe um formulário aberto para esta turma
    Quando eu acesso a aba de "Formulários Pendentes"
    Então eu não devo ver o formulário da turma "CIC0105 - ENGENHARIA DE SOFTWARE" na lista

  Cenário: [Triste] Não visualizar formulário que já foi respondido
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    E eu estou matriculado na turma "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
    E eu já respondi ao formulário de avaliação desta turma
    Quando eu acesso a aba de "Formulários Pendentes"
    Então eu não devo ver o formulário da turma "CIC0202 - PROGRAMAÇÃO CONCORRENTE" na lista
    E devo ver que não tem formulario pendente.