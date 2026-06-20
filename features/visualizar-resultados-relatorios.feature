Feature: Visualizar resultados dos formulários respondidos
  Como usuário administrador do sistema
  Quero conseguir visualizar os resultados dos formulários respondidos
  Para que eu consiga ter feedback preciso sobre o desempenho das turmas

  Background:
    Given que o usuário tem permissões para visualizar resultados
    And que o usuário está na aba de resultados
    And que existem as seguintes Turmas no sistema:
      | turma     | disciplina | semestre |
      | APC-T01   | APC        | 2026.1   |
      | OAC-T02   | OAC        | 2026.1   |
    And que existem os seguintes formulários no sistema:
      | nomeFormulario              | turma   | publicoAlvo | totalRespostas |
      | Avaliação APC 2026.1        | APC-T01 | Discente    | 25             |
      | Autoavaliação Docente APC   | APC-T01 | Docente     | 4              |
      | Avaliação OAC 2026.1        | OAC-T02 | Discente    | 0              |
      | Avaliação Confidencial APC  | APC-T01 | Discente    | 2              |

  Scenario Outline: Visualização dos resultados de um formulário respondido (Happy Path)
    When ele clica no botão "Resultados" do formulário "<nomeFormulario>"
    Then o sistema deve exibir a página de resultados do formulário "<nomeFormulario>"
    And deve mostrar o total de "<totalRespostas>" respostas recebidas
    And deve apresentar a distribuição das respostas para cada pergunta
    And deve apresentar os dados agregados em formato gráfico

    Examples:
      | nomeFormulario              | totalRespostas |
      | Avaliação APC 2026.1        | 25             |
      | Autoavaliação Docente APC   | 4              |

  Scenario Outline: Filtragem dos resultados por Turma (Happy Path)
    When ele seleciona a turma "<turma>" no filtro "Turma"
    Then o sistema deve listar apenas os formulários da turma "<turma>"
    And deve exibir o total de respostas de cada formulário listado

    Examples:
      | turma   |
      | APC-T01 |
      | OAC-T02 |

  Scenario Outline: Filtragem dos resultados por Público-Alvo (Happy Path)
    When ele seleciona "<publicoAlvo>" no filtro "Público-Alvo"
    Then o sistema deve listar apenas os formulários destinados a "<publicoAlvo>"
    And deve exibir o total de respostas de cada formulário listado

    Examples:
      | publicoAlvo |
      | Discente    |
      | Docente     |

  Scenario: Visualização de formulário sem respostas (Sad Path)
    When ele clica no botão "Resultados" do formulário "Avaliação OAC 2026.1"
    Then o sistema deve exibir a página de resultados do formulário "Avaliação OAC 2026.1"
    And deve exibir uma mensagem informando que o formulário ainda não recebeu respostas
    And não deve apresentar gráficos ou dados agregados

  Scenario: Visualização de formulário com respostas abaixo do mínimo para preservar anonimato (Sad Path)
    When ele clica no botão "Resultados" do formulário "Avaliação Confidencial APC"
    Then o sistema deve exibir a página de resultados do formulário "Avaliação Confidencial APC"
    And deve exibir uma mensagem informando que o número de respostas é insuficiente para divulgação
    And não deve apresentar a distribuição individual das respostas

  Scenario: Filtragem retorna nenhum formulário (Sad Path)
    Given que não existem formulários para a turma "TES-T04"
    When ele seleciona a turma "TES-T04" no filtro "Turma"
    Then o sistema não deve listar nenhum formulário
    And deve exibir uma mensagem informando que não há resultados para os filtros selecionados

  Scenario: Tentativa de acesso aos resultados por usuário sem permissão (Sad Path)
    Given que o usuário não tem permissões para visualizar resultados
    When ele tenta acessar a aba de resultados
    Then o sistema não deve permitir o acesso
    And ele deve ver "Acesso negado, a visualização de resultados requer privilégios de administrador"
