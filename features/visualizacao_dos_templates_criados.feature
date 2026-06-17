Feature: Visualização dos templates criados

  Eu como Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  @happy_path
  Scenario: Administrador visualiza a lista de templates com sucesso
    Given que existem os seguintes templates cadastrados no sistema:
      | titulo                     | descricao                  |
      | Avaliação Docente Padrão   | Avaliação semestral de UnB |
      | Feedback de Infraestrutura | Avaliação de laboratórios  |
    And que estou logado como um usuário Administrador
    When acesso a página de gerenciamento de templates
    Then devo ver uma lista contendo todos os templates cadastrados
    And devo visualizar o template "Avaliação Docente Padrão"
    And devo visualizar o template "Feedback de Infraestrutura"

  @sad_path
  Scenario: Administrador acessa a listagem mas não há templates cadastrados
    Given que não existem templates cadastrados no sistema
    And que estou logado como um usuário Administrador
    When acesso a página de gerenciamento de templates
    Then devo ver a mensagem "Nenhum template de formulário foi encontrado."