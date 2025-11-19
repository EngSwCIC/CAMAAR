Feature: Edição e deleção de templates
  Como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Background:
    Given que estou autenticado como administrador
    And existe um template com o nome "Template Turma Antiga"

  Scenario: Editar o nome de um template com sucesso (feliz)
    When eu clico para editar o template 
    And eu altero seu nome para "Template Turma Atualizada"
    Then o template deve ser salvo com o novo nome
    And os formulários já criados anteriormente não devem ser modificados
    And eu devo ver a mensagem "Template atualizado com sucesso"

  Scenario: Editar as perguntas de um template com sucesso (feliz)
    When eu clico para editar o template
    And eu altero suas perguntas
    Then o template deve ser salvo com as novas perguntas
    And os formulários já criados anteriormente não devem ser modificados
    And eu devo ver a mensagem "Template atualizado com sucesso"

  Scenario: Deletar um template com sucesso (feliz)
    When eu clico para deletar o template
    Then o template deve ser removido do sistema
    And os formulários já criados anteriormente devem permanecer intactos
    And eu devo ver a mensagem "Template excluído com sucesso"

  Scenario: Tentativa de salvar com nome em branco (triste)
    Given que eu clico para editar o template
    When eu apago o nome do template, deixando-o em branco
    And eu salvo as alterações
    Then eu devo ver a mensagem "Nome do template não pode ficar em branco"
    And o template deve continuar com o nome "Template Turma Antiga"

  Scenario: Tentar editar um template que está em uso por um formulário ativo (triste)
    Given que o template está vinculado a um formulário ativo
    When eu tento editar o template
    Then a alteração deve ser bloqueada
    And eu devo ver a mensagem "Não é possível editar um template em uso"

  Scenario: Tentar deletar um template que está em uso por um formulário ativo (triste)
    Given que o template está vinculado a um formulário ativo
    When eu tento deletar o template
    Then a remoção deve ser bloqueada
    And eu devo ver a mensagem "Não é possível remover um template em uso"

  Scenario: Edições em template não afetam formulários já criados (feliz)
    Given que criei Template V1 com 3 perguntas
    And criei Formulário A baseado em Template V1
    When eu edito Template V1 adicionando 1 pergunta
    And crio Formulário B baseado em Template V1 (agora com 4 perguntas)
    Then Formulário A deve manter as 3 perguntas originais
    And Formulário B deve ter as 4 novas perguntas

  Scenario: Admin de outro departamento não pode editar template (triste)
    Given que Admin A criou um template no Dept. X
    And Admin B pertence ao Dept. Y
    When Admin B tenta editar template de Admin A
    Then o sistema retorna erro 403
    And mensagem "Acesso negado"


