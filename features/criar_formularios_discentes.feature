Feature: Criar formulário para discente ou docente
  Como usuário administrador do sistema,
  Quero conseguir selecionar se o formulário a ser criado será destinado para alunos ou professores
  Para que eu consiga ter pleno controle sobre o público alvo do formulário

  Background:
    Given que o usuário tem permissões para criacao de Formulario
    And que o usuário está na aba de criação de formulários
    And que os seguintes Templates existem:
      | templateName  |
      | default       |
      | APC - 2026.1  |
    And que eles contém as seguintes Perguntas estilo radio:
      | Enunciado     | gabaritoRadio | opcoesRadio |
      | Pergunta um   | 3 | Um, Dois, Tres, Quatro  |
      | Como se sente?  | 3 | Muito Favoravel, Favoravel, Neutro, Desfavoravel, Muito Desfavoravel  |
    And que existem as seguintes Turmas no sistema:
      | turma     | disciplina | semestre |
      | APC-T01   | APC        | 2026.1   |
      | OAC-T02   | OAC        | 2026.1   |
      | VAZIA-T03 | TES        | 2026.1   |
    And que a turma "APC-T01" possui discentes matriculados e docentes vinculados
    And que a turma "OAC-T02" possui discentes matriculados e docentes vinculados
    And que a turma "VAZIA-T03" não possui discentes matriculados

  Scenario Outline: Criacao de Formulario para Discentes com Sucesso (Happy Path)
    When ele clica no botão "Criar Formulário"
    And escreve "<nomeFormulario>" em "Nome do Formulário"
    And seleciona "<templateName>" de "Templates"
    And seleciona "Discente" em "Público-Alvo"
    And seleciona "<turma>" em "Turma"
    And ele clica no botão "Criar"
    Then o usuário deve estar na aba de criação de formulários
    And o formulário "<nomeFormulario>" deve existir
    And o formulário deve estar disponível para os discentes da turma "<turma>"

    Examples:
      | nomeFormulario              | templateName | turma   |
      | Avaliação APC 2026.1        | default      | APC-T01 |
      | Formulário Discente - APC   | APC - 2026.1 | APC-T01 |
      | Avaliação de Disciplina OAC | default      | OAC-T02 |

  Scenario Outline: Criacao do Formulario para Docentes com Sucesso (Happy Path)
    When ele clica no botão "Criar Formulário"
    And escreve "<nomeFormulario>" em "Nome do Formulário"
    And seleciona "<templateName>" de "Templates"
    And seleciona "Docente" em "Público-Alvo"
    And seleciona "<turma>" em "Turma"
    And ele clica no botão "Criar"
    Then o usuário deve estar na aba de criação de formulários
    And o formulário "<nomeFormulario>" deve existir
    And o formulário deve estar disponível para os docentes da turma "<turma>"

    Examples:
      | nomeFormulario                  | templateName | turma   |
      | Autoavaliação Docente APC       | default      | APC-T01 |
      | Formulário Docente - APC 2026.1 | APC - 2026.1 | APC-T01 |
      | Autoavaliação Docente OAC       | default      | OAC-T02 |

  Scenario Outline: Falha na Criacao do Formulario - Não seleciona Público-Alvo (Sad Path)
    When ele clica no botão "Criar Formulário"
    And escreve "<nomeFormulario>" em "Nome do Formulário"
    And seleciona "<templateName>" de "Templates"
    And seleciona "<turma>" em "Turma"
    And ele clica no botão "Criar"
    Then o usuário deve estar na página do formulário de criação de formulários
    And ele deve ver "Formulario <nomeFormulario> não pode ser criado, por favor selecione o Público-Alvo"

    Examples:
      | nomeFormulario     | templateName | turma   |
      | formulario um      | default      | APC-T01 |
      | Avaliação sem alvo | APC - 2026.1 | OAC-T02 |

  Scenario Outline: Falha na Criacao do Formulario - Não seleciona Turma (Sad Path)
    When ele clica no botão "Criar Formulário"
    And escreve "<nomeFormulario>" em "Nome do Formulário"
    And seleciona "<templateName>" de "Templates"
    And seleciona "<publicoAlvo>" em "Público-Alvo"
    And ele clica no botão "Criar"
    Then o usuário deve estar na página do formulário de criação de formulários
    And ele deve ver "Formulario <nomeFormulario> não pode ser criado, por favor selecione uma Turma"

    Examples:
      | nomeFormulario     | templateName | publicoAlvo |
      | teste sem turma    | default      | Discente    |
      | Formulário Docente | APC - 2026.1 | Docente     |

  Scenario Outline: Falha na Criacao do Formulario - Turma sem Discentes Matriculados (Sad Path)
    When ele clica no botão "Criar Formulário"
    And escreve "<nomeFormulario>" em "Nome do Formulário"
    And seleciona "<templateName>" de "Templates"
    And seleciona "Discente" em "Público-Alvo"
    And seleciona "VAZIA-T03" em "Turma"
    And ele clica no botão "Criar"
    Then o usuário deve estar na página do formulário de criação de formulários
    And ele deve ver "Formulario <nomeFormulario> não pode ser criado, a turma selecionada não possui discentes matriculados"

    Examples:
      | nomeFormulario         | templateName |
      | formulario sem publico | default      |

  Scenario Outline: Falha na Criacao do Formulario - Nome do Formulário em branco (Sad Path)
    When ele clica no botão "Criar Formulário"
    And deixa o campo "Nome do Formulário" em branco
    And seleciona "<templateName>" de "Templates"
    And seleciona "<publicoAlvo>" em "Público-Alvo"
    And seleciona "<turma>" em "Turma"
    And ele clica no botão "Criar"
    Then o usuário deve estar na página do formulário de criação de formulários
    And ele deve ver "Formulario não pode ser criado, o nome do formulário é obrigatório"

    Examples:
      | templateName | publicoAlvo | turma   |
      | default      | Discente    | APC-T01 |
      | APC - 2026.1 | Docente     | OAC-T02 |

  Scenario Outline: Falha na Criacao do Formulario - Formulário com nome duplicado para a mesma Turma e Público-Alvo (Sad Path)
    Given já existe um formulário chamado "<nomeFormulario>" para o público "<publicoAlvo>" da turma "<turma>"
    When ele clica no botão "Criar Formulário"
    And escreve "<nomeFormulario>" em "Nome do Formulário"
    And seleciona "<templateName>" de "Templates"
    And seleciona "<publicoAlvo>" em "Público-Alvo"
    And seleciona "<turma>" em "Turma"
    And ele clica no botão "Criar"
    Then o usuário deve estar na página do formulário de criação de formulários
    And ele deve ver "Formulario <nomeFormulario> não pode ser criado, já existe um formulário com este nome para a turma e público-alvo selecionados"

    Examples:
      | nomeFormulario       | templateName | publicoAlvo | turma   |
      | Avaliação APC 2026.1 | default      | Discente    | APC-T01 |

  Scenario: Falha na Criacao do Formulario - Usuário sem permissão (Sad Path)
    Given que o usuário não tem permissões para criacao de Formulario
    When ele tenta acessar a aba de criação de formulários
    Then o sistema não deve permitir o acesso
    And ele deve ver "Acesso negado, a criação de formulários requer privilégios de administrador"
