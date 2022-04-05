Funcionalidade: Lista de questionarios disponiveis para serem respondidos
Eu como aluno
quero selecionar o questionario
A fim de responder perguntas sobre ele

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu esteja na página de responder relatório
  E que exista um botão "Adicionar Disciplina"

Cenario: Um Aluno deseja adicionar acessar um questionário específico, mas
esse questionário não está disponível (triste)
  Dado que o aluno conheça o questionário.
  Quando procurar pelo questionário
  Então ele deve retornar invalido ou não mostrar nenhum resultado da pesquisa

Cenario: Um Aluno deseja adicionar acessar um questionário específico e
esse questionário está disponível(feliz)
  Dado que o aluno conheça o questionário
  Quando procurar pelo questionário
  Então deve ser acessado o formulário correspondente em uma nova página.
