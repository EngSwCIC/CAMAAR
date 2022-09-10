Funcionalidade: Verificar na view se a senha de cadastro é valida
Como aluno, quero criar uma senha
A fim de finalizar o meu cadastro no sistema

Background:
  Dados que estou na página de cadastro
  Então eu devo ver um campo "Senha"
  
#Cenario Triste: Aluno digita senha sem letra maiuscula, letra minúscula ou números.
Cenario: Digitar senha inválida (triste)
  Dado que eu estou na pagina de cadastro
  Quando eu selecionar o campo senha 
  E digitar uma senha inválida
  E apertar "Confirmar"
  Então eu devo ver uma mensagem "Senha Inválida!"

# Cenario Feliz: Aluno digita senha valida com letra maiuscula, letra minúscula e números.
Cenario: Digitar senha válida (feliz)
  Dado que eu estou na pagina de cadastro
  Quando eu selecionar o campo senha 
  E digitar uma senha válida
  E apertar "Confirmar"
  Então eu devo ver uma mensagem "Cadastro feito com sucesso!"
