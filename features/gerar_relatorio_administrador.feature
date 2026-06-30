# language: pt

Funcionalidade: Gerar Relatório do Administrador
  Como administrador do sistema
  Quero gerar relatórios sobre os formulários e respostas dos estudantes
  Para que eu possa acompanhar e analisar os resultados das avaliações

  Cenário: Administrador gera relatório de respostas de um formulário
    Dado que estou logado como administrador
    E existe um formulário com respostas registradas
    Quando acesso a seção de relatórios e seleciono o formulário
    E clico em "Gerar relatório"
    Então o sistema exibe o relatório com todas as respostas consolidadas
    E posso visualizar as estatísticas de cada questão

  Cenário: Administrador exporta relatório em formato CSV
    Dado que estou logado como administrador
    E existe um relatório gerado para um formulário
    Quando clico em "Exportar CSV"
    Então o sistema realiza o download de um arquivo CSV
    E o arquivo contém todas as respostas dos estudantes

  Cenário: Administrador tenta gerar relatório de formulário sem respostas
    Dado que estou logado como administrador
    E existe um formulário que ainda não recebeu nenhuma resposta
    Quando acesso a seção de relatórios e seleciono o formulário
    E clico em "Gerar relatório"
    Então o sistema exibe uma mensagem informando que não há respostas registradas
    E não gera o relatório

  Cenário: Administrador tenta gerar relatório sem permissão
    Dado que estou logado como um usuário sem perfil de administrador
    Quando tento acessar a seção de relatórios
    Então o sistema nega o acesso
    E vejo uma mensagem informando que não tenho permissão para acessar esta funcionalidade
