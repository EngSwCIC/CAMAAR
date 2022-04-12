Funcionalidade: Adição de disciplina ao questionário durante a resposta
Eu como aluno
quero adicionar mais uma turma ao meu questionário
A fim de responder perguntas sobre ela

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu esteja na página de responder relatório
  E que exista um botão "Adicionar Disciplina"

Cenario: Um Aluno deseja adicionar uma nova diciplina ao questionario, mas a pesquisa ele não tem mais disciplinas livres (triste)
  Dado que já adicionei todas as disciplinas disponiveis para o meu perfil
  Quando eu tentar clicar no botão "Adicionar Disciplina"
  Então eu deveria ver o botão "Adicionar Disciplina" desabilitado

Cenario: Um Aluno adiciona uma nova disciplina disponível em um questionário (feliz)
  Dado que o aluno possua disciplinas ainda não adicionadas
  Quando o aluno  clicar no botão "Adicionar Disciplina"
  Então deve ser gerado um novo formulário, na mesma tela, com as perguntas relacionadas a disciplina adicionada

Cenario: Um Aluno deseja adicionar uma disciplina ao questionario, mas não está matriculado em nenhuma disciplina (triste)
  Dado que o aluno não está matriculado em nenhuma disciplina
  Quando ao tentar clicar no botão "Adicionar Disciplina"
  Então ele deveria ver o botão "Adicionar Disciplina" desabilitado

Cenario: Um Aluno deseja adicionar uma disciplina ao questionario e está matriculado em mais de uma disciplina (feliz)
  Dado que o aluno está matriculado em mais de uma disciplina
  Quando ao clicar no botão "Adicionar Disciplina"
  Então ele deve ter um dropdown com todas as disciplinas que ele está matriculado como opções de escolha
