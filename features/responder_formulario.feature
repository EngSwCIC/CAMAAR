Feature: Responder formulário
  Como um Participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

  Background:
    Given que existe um usuário com perfil de participante logado no sistema
    And que esse usuário possui vínculo ativo em uma turma
    And que existe um formulário de avaliação com status "aberto" para esta turma

  Scenario: Submissão de avaliação preenchendo os dados corretamente (Happy Path)
    Given que o formulário possui questões onde a marcação "obrigatória" é verdadeira
    When o participante acessa a página do questionário da sua turma
    And preenche todos os campos obrigatórios com respostas válidas
    And aciona a opção de "Submeter Avaliação"
    Then o sistema deve salvar as respostas do participante no banco de dados
    And deve registrar o momento exato do envio
    And deve redirecionar o usuário exibindo uma mensagem de agradecimento pela avaliação

  Scenario: Tentativa de envio de avaliação omitindo campos obrigatórios (Sad Path)
    Given que o formulário possui questões onde a marcação "obrigatória" é verdadeira
    When o participante acessa a página do questionário da sua turma
    And deixa as questões obrigatórias em branco
    And aciona a opção de "Submeter Avaliação"
    Then o sistema deve bloquear o envio do formulário
    And não deve criar nenhum registro de submissão no banco de dados
    And deve exibir uma notificação de erro indicando quais campos obrigatórios precisam ser preenchidos