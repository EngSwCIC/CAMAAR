# language: pt

Funcionalidade: Visualização de resultados dos formulários
  Como administrador
  Quero visualizar os resultados dos formulários criados
  A fim de acompanhar o andamento e o consolidado das avaliações anonimamente

  Cenário: [Feliz] Visualizar resultados de um formulário com respostas submetidas
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E existe um formulário de avaliação criado para a turma "CIC0097 - BANCOS DE DADOS" com respostas submetidas
    Quando eu acesso a página de "Resultados das Avaliações"
    E eu seleciono para visualizar os resultados deste formulário
    Então eu devo visualizar um painel com a média das notas e os comentários anonimizados

  Cenário: [Triste] Tentar visualizar resultados de um formulário sem avaliações submetidas
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E existe um formulário de avaliação criado para a turma "CIC0105 - ENGENHARIA DE SOFTWARE" sem respostas submetidas
    Quando eu acesso a página de "Resultados das Avaliações"
    E eu seleciono para visualizar os resultados deste formulário
    Então eu devo ver a mensagem "Ainda não há respostas suficientes para gerar a visualização deste formulário"

  Cenário: [Triste] Tentar acessar os resultados dos formulários sem permissão
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    Quando eu tento acessar a página de Resultados das Avaliações
    Então o sistema deve bloquear o acesso
    E exibir a mensagem de erro "Acesso negado: você não tem permissão para visualizar esta página"
