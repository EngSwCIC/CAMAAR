# language: pt
Funcionalidade: Visualização de resultados dos formulários

  Eu como Administrador do sistema CAMAAR quero visualizar os formularios criados
  A fim de poder gerar um relatório a pardir das respostas

  # FELIZ
  Cenário: Visualizar resultados dos formulários
    Dado que estou logado no sistema como administrador
    Quando acesso a página de avaliação
    E seleciono a opção de resultados dos formulários
    E visualizo a lista de turma e seus respectivos formulários
    Então visualizo os formulários que foram respondidos com sucesso


  # TRISTE
  Cenário: Erro ao carregar lista de resultados dos formulários
    Dado que estou logado no sistema
    Quando acesso a página de respostas de formulário
    Então vejo uma mensagem de erro informando que não foi possível carregar a listas de respostas dos formulários
    E sou instruído a tentar novamente mais tarde

 # TRISTE
  Cenário: Visualização de resultados dos formulários vazia
    Dado que estou logado no sistema como administrador
    Quando tento acessar a pagina de respostas dos formulários
    Então vejo uma lista vazia
    E visualizo uma mensagem de aviso que é necessario esperar que os formulários sejam respondidos