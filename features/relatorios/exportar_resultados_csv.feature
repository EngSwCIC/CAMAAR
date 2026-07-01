# language: pt
Funcionalidade: Exportar resultados
  Como Administrador
  Quero baixar um arquivo CSV contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas.

  Contexto:
    Dado que existe um usuário administrador cadastrado no sistema

  @happy
  Cenário: Administrador baixa arquivo CSV com respostas de um formulário do seu departamento
    Dado que estou autenticado como administrador do "Departamento de Ciência da Computação"
    E que existe um formulário com respostas para a turma "Engenharia de Software"
    Quando eu acesso a página de relatórios do meu departamento
    E solicito a exportação do formulário da turma "Engenharia de Software"
    Então o download do arquivo CSV deve ser iniciado
    E o CSV deve conter os dados esperados das avaliações

  @happy
  Cenário: Administrador exporta CSV de um formulário sem respostas
    Dado que estou autenticado como administrador do "Departamento de Ciência da Computação"
    E que existe um formulário sem respostas para a turma "Estrutura de Dados" do meu departamento
    Quando eu solicito a exportação do formulário da turma "Estrutura de Dados"
    Então o download do arquivo CSV deve ser iniciado
    E o arquivo CSV deve conter apenas a linha de cabeçalho

  @sad
  Cenário: Usuário não administrador tenta baixar arquivo CSV
    Dado que existe um usuário participante cadastrado no sistema
    E que estou autenticado como participante
    Quando eu tento acessar a rota de exportação de resultados em CSV
    Então devo ver uma mensagem informando que apenas administradores possuem acesso a este recurso
