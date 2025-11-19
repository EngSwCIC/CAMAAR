Feature: Responder questionário de avaliação da turma
  Como Participante de uma turma
  Eu quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

  Scenario: Acessar questionário disponível para avaliação (feliz)
    Given que estou autenticado no sistema como Participante
    And estou matriculado em uma turma que possui um questionário de avaliação aberto
    When eu acesso a área de avaliações da minha turma
    Then o sistema deve exibir o questionário disponível para resposta

  Scenario: Responder questionário com sucesso (feliz)
    Given que estou autenticado no sistema como Participante
    And existe um questionário de avaliação aberto para a turma em que estou matriculado
    When eu preencho todas as perguntas obrigatórias do questionário
    And submeto as respostas
    Then o sistema deve registrar minhas respostas
    And exibir uma confirmação de envio da avaliação

  Scenario: Tentativa de envio com respostas incompletas (triste)
    Given que estou autenticado no sistema como Participante
    And existe um questionário de avaliação aberto para a minha turma
    When eu tento submeter o questionário deixando perguntas obrigatórias em branco
    Then o sistema deve impedir a submissão
    And exibir uma mensagem informando que há perguntas obrigatórias não respondidas

  Scenario: Participante tenta responder um questionário já enviado (triste)
    Given que estou autenticado no sistema como Participante
    And já submeti anteriormente minha avaliação da turma
    When eu tento acessar novamente o questionário de avaliação
    Then o sistema deve informar que minha avaliação já foi enviada
    And não deve permitir uma nova submissão

  Scenario: Participante tenta responder questionário inexistente (triste)
    Given que estou autenticado no sistema como Participante
    And minha turma não possui questionário de avaliação disponível
    When eu acesso a área de avaliações da turma
    Then o sistema deve informar que não há avaliações disponíveis no momento

  Scenario: Participante tenta enviar resposta duplicada na mesma sessão (triste)
    Given que estou respondendo um formulário
    When eu clico "Enviar" com sucesso
    And imediatamente tenta enviar novamente
    Then o sistema deve bloquear
    And exibir "Esta resposta já foi submetida"
