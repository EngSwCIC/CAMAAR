Feature: Sistema de gerenciamento por departamento

  Eu como Administrador
  Quero gerenciar somente as turmas do departamento o qual eu pertenço
  A fim de avaliar o desempenho das turmas no semestre atual

  Background:
    Given que os dados do SIGAA para o semestre atual "2026.1" foram sincronizados
    And existem turmas cadastradas para o departamento "Ciência da Computação (CIC)"
    And existem turmas cadastradas para o departamento "Matemática (MAT)"
    And existe um usuário "Admin_CIC" autenticado com perfil de "Administrador"
    And o usuário "Admin_CIC" está vinculado institucionalmente ao departamento "Ciência da Computação (CIC)"

  @happy_path
  Scenario: Visualização da listagem de turmas restrita ao próprio departamento
    Given que o "Admin_CIC" acessa o painel de gerenciamento de turmas do semestre atual
    When a listagem de turmas for carregada na tela
    Then ele deve visualizar as disciplinas referentes ao departamento "Ciência da Computação (CIC)", como "Engenharia de Software"
    And a lista não deve exibir nenhuma disciplina referente ao departamento "Matemática (MAT)", como "Cálculo 1"

  @sad_path
  Scenario: Tentativa de acesso direto a uma turma de outro departamento via URL
    Given que a turma de "Cálculo 1" pertence ao departamento "Matemática (MAT)" e possui o ID de sistema "999"
    When o "Admin_CIC" tenta forçar o acesso digitando diretamente a URL "/admin/turmas/999/avaliacoes"
    Then o sistema deve interceptar a requisição e bloquear o acesso
    And deve redirecionar o usuário para o painel principal do seu departamento
    And exibir a mensagem de erro "Acesso negado: Você tem permissão para gerenciar apenas as turmas vinculadas ao seu departamento."
