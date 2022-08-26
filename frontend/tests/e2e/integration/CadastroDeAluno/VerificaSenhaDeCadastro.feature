Funcionalidade: Verificar na view se a senha de cadastro é vaĺida
Como aluno, quero criar uma senha
A fim de finalizar o meu cadastro no sistema

#Cenario Triste: Aluno digita senha sem letra maiuscula, letra minúscula ou números.
Cenario: Digitar senha inválida (triste)
  Dado que eu estou na pagina de cadastro
  Quando eu selecionar o campo senha 
  E digitar uma senha inválida
  Então eu devo ver uma mensagem "Senha Inválida!"

# Cenario Feliz: Aluno digita senha valida com letra maiuscula, letra minúscula e números.
Cenario: Digitar senha válida (feliz)
  Dado que eu estou na pagina de cadastro
  Quando eu selecionar o campo senha 
  E digitar uma senha válida
  Então eu devo ver uma mensagem "Cadastro feito com sucesso!"
