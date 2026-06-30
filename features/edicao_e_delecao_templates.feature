Feature: Edicao e Delecao de Templates
Como Administrador/Professor,
Para que possa organizar e atualizar minhas templates,
Quero poder editar minhas templates existentes e deleta-las.

  Background:
    Given que o seguinte Template existe:
    | nomeTemplate    | enunciadoRadio  | quantidadeOpcoes  | opcoes  | respostaRadio | enunciadoDiscursiva | gabaritoDiscursiva  |
    | Template Teste  | Opções          | 3                 | 1, 2, 3 | Opção 3       | Pergunta?           | Resposta!           |
    And que o usuário está na aba de Edicao de Templates 
  

  Scenario Outline: Edicao de Template - Adicionar Pergunta Discursiva (Happy Path)
    When ele clica no botão "Editar" de "Template Test"
    And ele cria uma questão "Discursiva" com "<enunciadoDiscursiva>" e "<gabaritoDiscursiva>"
    And ele clica no botão "Terminar"
    Then o usuário deve estar na aba de Edicao de Templates

  Examples:
  | nomeTemplate    | enunciado                       | resposta          |
  | Template Teste  | Pergunta?                       | Resposta!         |
  | Resposta Aberta | Qual sua opinião sobre o curso? | Resposta aberta   |
  | Se Conhecer     | Fale um pouco sobre você!       | Resposta pessoal  |



  Scenario Outline: Edicao de Template - Adicionar Pergunta Radio (Happy Path)
    When ele clica no botão "Editar" de "Template Test"
    And ele cria uma questão "Radio" com "<enunciado>" e "<resposta>" com "<quantidadeOpcoes>" opções, cujas são "<opcoes>"
    And ele clica no botão "Terminar"
    And ele clica no botão "Ver Template" de "Template Teste"
    Then ele deve ver "<enunciado>"
    And ele deve ver "<opcoes>"

  Examples:
  | enunciado                         | quantidadeOpcoes  | opcoes                                  | resposta      |
  | Como você se sente sobre o curso? | 5                 | Muito Bem, Bem, Neutro, Mal, Muito Mal  | Sem Gabarito  |
  | Quanto é 2+2?                     | 4                 | 3, 4, 21, 773.237, N/A                  | Opção 2       |


  Scenario: Edicao de Template - Remover Pergunta (Happy Path)
    When ele clica no botão "Editar" de "Template Test"
    And ele clica no botão "Remover Pergunta" de "Opções" 
    And ele clica no botão "Terminar"
    And ele clica no botão "Ver Template" de "Template Teste"
    Then ele não deve ver "Opções"
    And ele deve ver "Pergunta?"



  Scenario: Edicao de Template - Mudar enunciado de Pergunta (Happy Path)
    When ele clica no botão "Editar" de "Template Test"
    And escreve "Novo Enunciado" em "Enunciado1"
    And ele clica no botão "Terminar"
    And ele clica no botão "Ver Template" de "Template Teste"
    Then ele deve ver "Novo Enunciado"
    And ele não deve ver "Opções"


  Scenario: Edicao de Template - Mudar gabarito de Pergunta Discursiva (Happy Path)
    When ele clica no botão "Editar" de "Template Test"
    And escreve "Novo Gabarito" em "Gabarito2"
    And ele clica no botão "Terminar"
    And ele clica no botão "Ver Template" de "Template Teste"
    Then ele deve ver "Novo Gabarito"
    And ele não deve ver "Resposta!"


  Scenario: Edicao de Template - Mudar gabarito de Pergunta Radio (Happy Path)
    When ele clica no botão "Editar" de "Template Test"
    And ele seleciona "Sem Gabarito" de "Gabarito"
    And ele clica no botão "Terminar"
    And ele clica no botão "Ver Template" de "Template Teste"
    Then ele deve ver "Sem Gabarito"
    And ele não deve ver "Opção 3"


  Scenario: Delecao de Template (Happy Path)
    When ele clica no botão "Deletar" de "Template Test"
    Then ele não deve ver "Template Test"






  Scenario: Salvar edicao sem Perguntas (Sad Path)
    When ele clica no botão "Editar" de "Template Test"
    And ele clica no botão "Remover Pergunta" de "Opções" 
    And ele clica no botão "Remover Pergunta" de "Pergunta?"
    And ele clica no botão "Terminar"
    Then ele deve estar na página de Edicao de Templates
    And ele deve ver "Template sem Perguntas. Adicione uma Pergunta para Salvar."
  

  Scenario: Salvar edicao com Enunciado de Pergunta em Branco (Sad Path)
    When ele clica no botão "Editar" de "Template Test"
    And escreve nada em "Enunciado1"
    And ele clica no botão "Terminar"
    Then ele deve estar na página de Edicao de Templates
    And ele deve ver "Alguma caixa está vazia. Certifique-se de que tudo está preenchido para Salvar."



