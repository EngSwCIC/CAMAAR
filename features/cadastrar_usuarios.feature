Feature: Cadastrar usuários do sistema
  Como Administrador
  Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
  A fim de que eles acessem o sistema CAMAAR

  Background:
    Given que o administrador está autenticado no módulo de gerenciamento do sistema
    And que os dados exportados do SIGAA estão disponíveis para processamento

  Scenario: Importação de participantes inéditos e solicitação de senha (Happy Path)
    Given que o arquivo de importação contém um novo participante com e-mail e matrícula preenchidos corretamente
    When o administrador executa a rotina de importação dos participantes para uma turma
    Then o sistema deve criar um pré-cadastro vinculando este usuário à sua respectiva turma
    And deve enviar automaticamente um e-mail para o participante com o link de definição de senha
    And o status da conta deve permanecer como pendente
    And o cadastro do usuário só deve ser efetivado de fato no sistema após a conclusão da definição da senha

  Scenario: Importação ignorada para participante sem dados obrigatórios (Sad Path)
    Given que o arquivo de importação contém um participante com dados inconsistentes, como a ausência de e-mail ou matrícula
    When o administrador executa a rotina de importação dos participantes para uma turma
    Then o sistema não deve criar um pré-cadastro para o participante inválido
    And não deve disparar nenhuma solicitação de definição de senha
    And deve registrar o erro de consistência para este usuário específico e continuar processando o restante do arquivo