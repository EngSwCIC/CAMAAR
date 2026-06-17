Feature: Exportação de Relatórios de Avaliação
  Como um usuário com privilégios de Administrador
  Quero extrair os resultados consolidados das avaliações em um arquivo CSV
  Para realizar a análise de desempenho acadêmico fora da plataforma

  Background:
    Given que a base de dados possui a pesquisa "Avaliação de Turmas CIC" registrada
    And o sistema já processou as respostas submetidas pelos discentes

  @happy_path
  Scenario: Happy Path - Download bem-sucedido de CSV para uma avaliação já encerrada
    Given que estou devidamente autenticado com credenciais de "Administrador"
    And a pesquisa "Avaliação de Turmas CIC" encontra-se com o status "Encerrada"
    When eu navego até o módulo de "Relatórios Gerenciais"
    And aciono o comando para exportar os dados desta pesquisa
    Then o sistema deve processar as informações no backend
    And iniciar o download de um arquivo com a extensão ".csv"
    And o conteúdo do arquivo deve refletir exatamente as respostas tabuladas da turma

  @sad_path
  Scenario: Sad Path - Bloqueio de geração de relatório para avaliações que ainda estão abertas
    Given que estou devidamente autenticado com credenciais de "Administrador"
    And a pesquisa "Avaliação de Turmas CIC" ainda encontra-se com o status "Em Andamento"
    When eu tento exportar os dados desta pesquisa no módulo de "Relatórios Gerenciais"
    Then a ação de exportação deve ser bloqueada pela interface
    And o sistema deve exibir a mensagem de restrição "Relatórios só podem ser gerados para avaliações encerradas."

  @sad_path
  Scenario: Sad Path - Tentativa de violação de acesso à rota de relatórios por usuário sem permissão
    Given que estou logado no sistema com o perfil padrão de "Docente"
    When eu tento forçar a requisição diretamente pela URL de exportação "/admin/relatorios/csv"
    Then o servidor deve recusar o acesso
    And eu devo ser redirecionado para a página inicial (dashboard)
    And o sistema deve exibir o alerta de segurança "Acesso negado. Apenas administradores podem gerar este relatório."