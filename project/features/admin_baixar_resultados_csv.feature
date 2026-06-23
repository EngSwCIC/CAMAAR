# language: pt
Funcionalidade: Exportação de resultados de formulário em CSV

  Como um Administrador
  Quero baixar um arquivo csv contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas

  Cenário: Download de resultados em CSV com sucesso
    Dado que estou logado no sistema como "Administrador"
    E que estou na página de visualização de resultados da turma "Estrutura de Dados"
    Quando o formulário selecionado já possui respostas submetidas
    E eu clico no botão "Exportar Resultados (CSV)"
    Então o sistema deve gerar um arquivo ".csv" com todas as respostas estruturadas
    E o download do arquivo deve iniciar automaticamente no meu navegador

  Cenário: Tentativa de download de CSV de um formulário sem respostas
    Dado que estou logado no sistema como "Administrador"
    E que estou na página de visualização de resultados de um formulário recém-criado
    Quando o formulário selecionado ainda não possui nenhuma resposta de participante
    E eu clico no botão "Exportar Resultados (CSV)"
    Então o sistema não deve gerar o arquivo
    E deve exibir um alerta impeditivo "Não é possível exportar o relatório pois nenhuma resposta foi registrada. Aguarde os participantes responderem."