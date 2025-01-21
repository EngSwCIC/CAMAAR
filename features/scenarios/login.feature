Feature: Sistema de Login
  As um Usuário do sistema
  I want acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  In order to responder formulários ou gerenciar o sistema

  Scenario: Login bem-sucedido como administrador
    Given que eu estou na página de login
    When eu preencho o campo "email" com "admin@example.com"
    And eu preencho o campo "senha" com "senha123"
    And eu clico em "Entrar"
    Then eu devo ver o menu lateral com a opção "Gerenciamento"

  Scenario Outline: Login de aluno com sucesso 
        Given que o usuário está na página de login
        When o usuário preenche o campo "email" com "<email>"
        And o usuário preenche o campo "senha" com "<senha>"
        And o usuário clica no botão "Entrar"
        Then o usuário deve ser capaz de ver a aba de avaliações

    Examples:
        | email             | senha   |
        | user@example.com  | 123456  |
        | aluno@example.com | 111111  |

    Scenario Outline: Login de aluno com falha
        Given que o usuário está na página de login
        When o usuário preenche o campo "email" com "<email>"
        And o usuário preenche o campo "senha" com "<senha>"
        And o usuário clica no botão "Entrar"
        Then o usuário deve ser capaz de ver a mensagem de erro

    Examples:
        | email             | senha   |
        |                   | 123456  |
        | aluno@example     | 111111  |
        | User@example.com  |         |