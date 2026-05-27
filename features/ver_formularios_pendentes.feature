Feature: Ver formulários pendentes
Como Usuário (Professor ou Estudante),
Para que eu possa preencher os formulários atribuídos à mim,
Quero ver todos os formulários que preciso preencher em uma aba específica à este intuito.

  Background:
    Given que os seguintes usuários existam:
      | nome | perfil    | email             |
      | Igor | Estudante | igor@escola.com   |
      | Ana  | Professor | ana@escola.com    |

  Scenario Outline: Usuário tem formulários pendentes (Happy Path)
    Given que o usuário esta logado como "<email>"
    And os seguintes formulários estão atribuidos ao usuário:
      | nomeFormulario  |
      | Formulário Opcional |
      | Formulário Um   |
      | Formulário Introdutório |
    When o usuário acessa a aba de "Formulários Pendentes"
    Then ele deve ver "Formulário Opcional"  
    And ele deve ver "Formulário Um"  
    And ele deve ver "Formulário Introdutório"  

  Examples:
    | email           |
    | igor@escola.com |
    | ana@escola.com  |



  Scenario Outline: Usuário não tem formulários pendentes (Happy Path)
    Given que o usuário esta logado como "<email>"
    And não existem formulários atribuidos ao usuário
    When o usuário acessa a aba de "Formulários Pendentes"
    Then ele deve ver "Você está em dia! Sem formulários para preencher."
  
  Examples:
    | email           |
    | igor@escola.com |
    | ana@escola.com  |

  




  Scenario: Usuário não está logado (Sad Path)
    Given que o usuário não está logado
    When o usuário acessa a aba de "Formulários Pendentes"
    Then o usuário deve ser redirecionado à página de Login
    And ele deve ver "É necessário estar logado para acessar está página."
