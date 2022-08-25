#language: pt
Funcionalidade: Envio do email para cada aluno com link para a view de cadastro de senha
Como aluno, quero receber um link em meu e-mail 
A fim de finalizar o meu cadastro no sistema, incluindo uma senha

#Cenario Triste: O professor importa suas turmas e um ou mais alunos não possuem e-mail
Cenario: Não há e-mail registrado para o aluno (triste)
  Quando eu clicar no botão "Buscar turmas no SIGAA"
  Dado que os alunos foram importados com sucesso
  Então eu deveria ver uma lista na tela informando nome e matrícula do aluno sem e-mail cadastrado 

# Cenario Feliz: O professor importa suas turmas e o sistema envia links para finalizar o cadastro de cada aluno
Cenario: Aluno é importado com e-mail (feliz)
  Quando eu clicar no botão "Buscar turmas no SIGAA"
  Dado que um aluno foi importado com sucesso
  E não possui cadastro prévio
  Então o sistema envia um e-mail contendo um link para finalizar o cadastro
