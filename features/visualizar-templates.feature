Feature: Visualizar templates criados
  Como Administrador
  Quero visualizar os templates criados
  Para gerenciar, editar e deletar templates conforme necessidade

  Scenario: Visualizar templates com sucesso
    Given que estou logado como administrador
    And existem templates cadastrados
    When acesso a página de templates
    Then vejo a lista de templates já criados
    And tenho acesso às opções de edição e exclusão de cada template

  Scenario: Erro ao carregar templates
    Given que estou logado como administrador
    And ocorre uma falha ao buscar os templates no sistema
    When acesso a página de templates
    Then o sistema exibe uma mensagem de erro informando que não foi possível carregar os templates
    And nenhum template é exibido na tela

