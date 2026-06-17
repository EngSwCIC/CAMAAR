Feature: Edição e deleção de templates
    Eu como Administrador
    Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
    A fim de organizar os templates existentes

  Background:
    Given que o administrador esteja autenticado no sistema
    And que exista ao menos um template criado por esse administrador

  Scenario: Edição de template com informações válidas
    When o administrador navega até a lista de templates disponíveis
    And seleciona um template para editar
    And realiza modificações válidas em seu conteúdo
    And salva as alterações realizadas
    Then o sistema deve atualizar o template com as novas informações
    And os formulários previamente gerados a partir desse template devem permanecer inalterados
    And uma mensagem de confirmação deve ser exibida ao administrador

  Scenario: Tentativa de edição de template com informações inválidas
    When o administrador navega até a lista de templates disponíveis
    And seleciona um template para editar
    And substitui informações obrigatórias por dados inválidos ou em branco
    And tenta salvar as alterações
    Then o sistema deve bloquear o salvamento
    And exibir uma mensagem de erro apontando os campos que precisam ser corrigidos
