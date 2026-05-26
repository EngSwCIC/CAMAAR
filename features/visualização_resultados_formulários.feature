Feature: Visualização de resultados dos formulários
  Como Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Background:
    Given que o usuário está logado no sistema com o perfil de Administrador

  Scenario: Visualizar a lista de formulários para geração de relatório (Happy Path)
    Given que existem formulários previamente cadastrados e com respostas coletadas no sistema
    When o administrador navega até a página de visualização de formulários
    Then o sistema deve exibir a lista contendo os formulários existentes
    And cada item da lista deve mostrar os detalhes do formulário, como nome e turma
    And o sistema deve disponibilizar um botão para gerar o relatório a partir das respostas daquele formulário

  Scenario: Acessar a página de formulários quando a base está vazia (Sad Path)
    Given que não há nenhum formulário criado ou registrado no banco de dados do sistema
    When o administrador navega até a página de visualização de formulários
    Then o sistema deve apresentar a tela sem nenhuma listagem de dados
    And deve exibir a mensagem informativa "Não existem formulários disponíveis para gerar relatórios no momento"