# language: pt
# encoding: utf-8

Funcionalidade: Exibir Manual do Usuário
Eu como aluno 
Quero um manual das funcionalidades da página 
A fim de auxiliar o usuário a utilizar os recursos

  Contexto:
    Dado que eu esteja logado como aluno no CAMAAR
    E eu esteja na página de relatório do aluno

  # Cenario Triste abrir o manual e encontrar uma informação errada
  Cenario: Um Aluno abre o manual do usuário e o que está escrito não corresponde à funcionalidade da página
  Dado que exista um botão "Pesquisar" que não esteja funcionando
  Quando eu clicar no botão "Reportar Erro"
  Então deve aparecer uma mensagem na tela dizendo "Email para reportar erros: xxxxxxx@unb.com.br"

  # Cenario Feliz o aluno tem uma dúvida e encontra a solução no manual
  Cenario: Um Aluno abre o manual do usuário e o que está escrito corresponde à funcionalidade da página 
  Dado que exista um botão "Manual do Usuário"
  Quando eu clicar no botão "Manual do Usuário"
  Então deve aparecer um arquivo aberto "Manual do Usuário"
