@issue-110 (Visualização de formulários criados)
Funcionalidade: Visualização de Formulários para Geração de Relatório
  Como administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Contexto:
    Dado que o administrador está autenticado
    E existe o formulário "F-CIC101" (Avaliação da turma CIC101) criado por ele
    E o formulário "F-MAT001" (Avaliação da turma MAT001) foi criado por outro administrador
    E o formulário "F-CIC101" possui 10 respostas registradas
    E o administrador acessa a área de "Gerenciamento de Formulários"

  Cenário: Visualizar e filtrar formulários criados
    Quando o administrador visualiza a lista de formulários
    Então o sistema deve exibir o formulário "F-CIC101" com a indicação de "10 respostas"
    E o sistema deve permitir a aplicação de filtros por turma e status (Aberto/Fechado)

  Cenário: Acesso à geração de relatório
    Quando o administrador seleciona o formulário "F-CIC101"
    E clica na opção "Gerar Relatório"
    Então o sistema deve exibir a tela de configuração de relatório
    E deve permitir a exportação dos dados e indicadores de desempenho

  Cenário: Formulário sem respostas
    Dado que o formulário "F-MAT100" possui "0 respostas"
    Quando o administrador tenta gerar o relatório para "F-MAT100"
    Então o sistema deve exibir a mensagem "Não é possível gerar relatório, pois não há respostas"