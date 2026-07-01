# language: pt

Funcionalidade: Gerar relatório do administrador
  Como administrador
  Quero baixar um arquivo CSV com os resultados de um formulário específico
  A fim de analisar os dados e métricas de avaliação detalhadamente

  Cenário: [Feliz] Baixar CSV com resultados de um formulário com respostas
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E existe um formulário criado para a turma "CIC0097 - BANCOS DE DADOS" com respostas submetidas
    Quando eu acesso a página de "Gerar Relatórios"
    E eu seleciono o formulário da turma "CIC0097 - BANCOS DE DADOS"
    E eu aciono a opção "Exportar para CSV"
    Então o sistema deve gerar o arquivo de CSV resultados
    E iniciar automaticamente o download do arquivo ".csv" correspondente

  Cenário: [Triste] Tentar baixar CSV de um formulário sem respostas submetidas
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E existe um formulário criado para a turma "CIC0105 - ENGENHARIA DE SOFTWARE" sem respostas submetidas
    Quando eu acesso a página de "Gerar Relatórios"
    E eu seleciono o formulário da turma "CIC0105 - ENGENHARIA DE SOFTWARE"
    E eu tento acionar a opção "Exportar para CSV"
    Então o sistema deve exibir a mensagem de erro "Não há dados suficientes para exportar este formulário"
    E o download não deve ser iniciado

  Cenário: [Triste] Tentar baixar CSV com resultados de um formulário sem permissão de administrador
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    Quando eu tento acessar diretamente à URL de exportação de dados em CSV de um formulário
    Então o sistema deve bloquear a ação
    E exibir a mensagem de erro "Acesso negado: você não tem permissão para exportar dados"
