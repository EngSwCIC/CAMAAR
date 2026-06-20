Feature: Criacao de Template de Formulario
Como Professor ou Administrador,
Para que eu possa avaliar turmas e ser especifico na minha avaliação,
Quero poder criar templates de formulario das quais criarei formularios futuramente



  Scenario Outline: Chegar na página de Criação de Template de Formulário
    Given que o usuário tem permissões para criacao de Formulario
    And ele está na aba criação de Templates de Formulário
    When ele clica no botão "Criar Template"
    And escreve "<nomeTemplate>" em "Nome da Template de Formulário"
    And ele clica no botão "Montar Template" 
    Then o usuário deve estar na página de criação de Template de Formulário
    And ele deve ver "<nomeTemplate>"

  Examples:
  | nomeTemplate          |
  | Template Generica     |
  | Formulario de Opinião |



  Scenario: Criação de Pergunta tipo Discursiva
    Given que o usuário está montando um Template
    When ele seleciona "Discursiva" de "Tipo de Questão"
    And escreve "Pergunta?" em "Enunciado"
    And escreve "Resposta" em "Gabarito"
    And ele clica no botão "Adicionar Questão"
    Then ele deve ver "Pergunta?"



  Scenario Outline: Criação de Pergunta tipo Radio
    Given que o usuário está montando um Template
    When ele seleciona "Radio" de "Tipo de Questão"
    And escreve "Opções" em "Enunciado"
    And ele seleciona "<quantidadeOpcoes>" de "Quantidade de Opções"
    And ele preenche as primeiras "<quantidadeOpcoes>" opções com "<opcoes>"
    And ele seleciona "<resposta>" de "Gabarito"
    And ele clica no botão "Adicionar Questão"
    Then ele deve ver "Opções"

    Examples:
    | quantidadeOpcoes | opcoes                                 | resposta |
    | 3                | Azul, Verde, Vermelho, N/A, N/A        | Opção 1  |
    | 4                | Carro, Moto, Bike, Trem, N/A           | Opção 2  |
    | 5                | Alface, Tomate, Batata, Cebola, Alho   | Opção 3  |






  Scenario Outline: Sucesso na criação de uma Template - Uma questão discursiva (Happy Path)
    Given que o usuário está montando o Template "<nomeTemplate>"
    When ele cria uma questão "Discursiva" com "<enunciado>" e "<resposta>"
    And ele clica no botão "Criar Template"
    Then o usuário deve estar na aba criação de Templates de Formulário
    And ele deve ver "<nomeTemplate>"

  Examples:
  | nomeTemplate    | enunciado                       | resposta          |
  | Template Teste  | Pergunta?                       | Resposta!         |
  | Resposta Aberta | Qual sua opinião sobre o curso? | Resposta aberta   |
  | Se Conhecer     | Fale um pouco sobre você!       | Resposta pessoal  |



  Scenario Outline: Sucesso na criação de uma Template - Uma questão tipo radio (Happy Path)
    Given que o usuário está montando o Template "<nomeTemplate>"
    When ele cria uma questão "Radio" com "<enunciado>" e "<resposta>" com "<quantidadeOpcoes>" opções, cujas são "<opcoes>"
    And ele clica no botão "Criar Template"
    Then o usuário deve estar na aba criação de Templates de Formulário
    And ele deve ver "<nomeTemplate>"

  Examples:
  | nomeTemplate    | enunciado                         | quantidadeOpcoes  | opcoes                                  | resposta      |
  | Template Teste  | Opções                            | 3                 | 1, 2, 3, N/A, N/A                       | Opção 3       |
  | Opinião Curso   | Como você se sente sobre o curso? | 5                 | Muito Bem, Bem, Neutro, Mal, Muito Mal  | Sem Gabarito  |
  | Matemática      | Quanto é 2+2?                     | 4                 | 3, 4, 21, 773.237, N/A                  | Opção 2       |



  Scenario Outline: Sucesso na criação de uma Template - Uma questão discursiva e uma tipo radio (Happy Path)
    Given que o usuário está montando o Template "<nomeTemplate>"
    When ele cria uma questão "Radio" com "<enunciadoRadio>" e "<respostaRadio>" com "<quantidadeOpcoes>" opções, cujas são "<opcoes>"
    And ele cria uma questão "Discursiva" com "<enunciadoDiscursiva>" e "<gabaritoDiscursiva>"
    And ele clica no botão "Criar Template"
    Then o usuário deve estar na aba criação de Templates de Formulário
    And ele deve ver "<nomeTemplate>"

    Examples:
    | nomeTemplate    | enunciadoRadio                    | quantidadeOpcoes  | opcoes  | respostaRadio | enunciadoDiscursiva                             | gabaritoDiscursiva  |
    | Template Teste  | Opções                            | 3 | 1, 2, 3, N/A, N/A                       | Opção 3       | Pergunta?                       | Resposta!           |
    | Opinião Curso   | Como você se sente sobre o curso? | 5 | Muito Bem, Bem, Neutro, Mal, Muito Mal  | Sem Gabarito  | Qual sua opinião sobre o curso? | Resposta aberta     |
    | Matemática      | Quanto é 2+2?                     | 4 | 3, 4, 21, 773.237, N/A                  | Opção 2       | Fale um pouco sobre você!       | Resposta pessoal    |
  





  Scenario Outline: Falha na criação de uma Template - Sem questões (Sad Path)
    Given que o usuário está montando o Template "<nomeTemplate>"
    And ele clica no botão "Criar Template"
    Then o usuário deve estar na página de criação de Templates de Formulário
    And ele deve ver "Template <nomeTemplate> não pode ser criada, por favor adicione uma Questão"
  
  Examples:
  | nomeTemplate          |
  | Template Generica     |
  | Formulario de Opinião |
  | Formulario Técnico    |