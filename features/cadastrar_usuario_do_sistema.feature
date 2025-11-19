Feature: Importação de participantes do SIGAA
  Como Administrador
  Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos para o sistema
  A fim de que eles acessem o sistema CAMAAR

  Scenario: Administrador importa participantes de uma turma do SIGAA (feliz)
    Given que estou autenticado como Administrador
    And estou na seção "Gerenciamento"
    When eu seleciono a opção "Importar Participantes do SIGAA"
    And escolho a turma "Turma A"
    And confirmo a importação
    Then o sistema deve importar os dados dos usuários da turma "Turma A"
    And deve registrar que os usuários importados estão pendentes de definição de senha

  Scenario: Sistema envia solicitação para definição de senha aos usuários importados (feliz)
    Given que usuários foram importados da turma "Turma A"
    And estão marcados como pendentes de definição de senha
    When a importação é concluída
    Then o sistema deve enviar uma solicitação para definição de senha para cada usuário novo importado

  Scenario: Usuário define a senha pela primeira vez (feliz)
    Given que um usuário foi importado e está pendente de definição de senha
    When o usuário acessa o link de definição de senha enviado pelo sistema
    And informa uma nova senha válida
    Then o sistema deve registrar a senha do usuário
    And o cadastro do usuário deve ser efetivado
    And o usuário deve estar apto a acessar o sistema CAMAAR

  Scenario: Usuário tenta acessar o sistema sem ter definido a senha (triste)
    Given que um usuário foi importado e está pendente de definição de senha
    When o usuário tenta acessar o sistema CAMAAR
    Then o sistema deve impedir o acesso
    And deve informar que a senha deve ser definida antes do primeiro acesso

  Scenario: Administrador importa usuários já existentes no sistema (triste)
    Given que estou autenticado como Administrador
    And estou na seção "Importar Participantes do SIGAA"
    When eu importo uma turma que contém usuários já cadastrados no CAMAAR
    Then o sistema não deve recriar esses usuários
    And deve apenas associá-los à turma importada

  Scenario: Administrador tenta importar turma sem selecionar uma turma (triste)
    Given que estou autenticado como Administrador
    When eu tento iniciar a importação sem selecionar uma turma
    Then o sistema deve informar que é necessário escolher uma turma
    And não deve iniciar a importação

  Scenario: Importação falha devido a erro no SIGAA (triste)
    Given que estou autenticado como Administrador
    And estou na página de importação de participantes
    When ocorre uma falha na comunicação com o SIGAA
    Then o sistema deve informar que não foi possível completar a importação
    And não deve registrar nenhum usuário como importado
