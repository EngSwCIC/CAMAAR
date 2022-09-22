#language: pt
Funcionalidade: Visualizar avaliações de turmas que me matriculei ou desejo matricular
Eu como aluno
Quero visualizar qualquer uma das turmas do CIC
A fim de poder escolher uma turma para analisar

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu estou na página de relatório do aluno

Cenario: Não há nenhuma turma registrada para a disciplina (triste)
  Dado que nenhuma turma está cadastrada no sistema
  Quando eu clicar na disciplina 'CIC0105'
  Então eu deveria ver uma mensagem na tela dizendo "Nenhuma turma cadastrada"

# Cenario Feliz o aluno consegue gerar o relatório com sucesso
Cenario: Visualiza turma cadastrada no CAMAAR (feliz)
  Dado que a turma 'A' da disciplina 'CIC0105' está cadastrada no CAMAAR
  Quando eu clicar na disciplina 'CIC0105'
  Então eu deveria ver a turma 'A'
  # E eu deveria ver nome do(a) professor(a) da disciplina 'CIC0105' da turma 'A'

Cenario: Visualiza dados da turma cadastrada no CAMAAR (feliz)
  Dado que a turma 'A' da disciplina 'CIC0105' está cadastrada no CAMAAR
  Quando eu clicar na disciplina 'CIC0105'
  E eu clicar na turma 'A' da disciplina 'CIC0105'
  Então eu deveria ver os dados da turma 'A'
