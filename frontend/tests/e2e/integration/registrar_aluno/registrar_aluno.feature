# language: pt
# encoding: utf-8

Funcionalidade: Cadastrar alunos do sistema
  Eu como Administrador
  Quero cadastrar alunos do CIC
  A fim de que eles acessem o sistema CAMAAR

Contexto:
  Dado que eu esteja na página de registro de aluno

Cenário: Registrar com campos válidos (happy path)
  Quando eu escrever "nome" no campo nome
  E eu escrever "curso" no campo curso
  E eu escrever "123456789" no campo matricula
  E eu escrever "joe" no campo usuario
  E eu escrever "joe@example.com" no campo email
  E eu clicar em "registrar"
  Então o registro deve suceder

Cenário: Registrar com campos inválidos (sad path)
  Quando eu escrever "" no campo nome
  E eu escrever "" no campo curso
  E eu escrever "" no campo matricula
  E eu escrever "" no campo usuario
  E eu escrever "" no campo email
  E eu clicar em "registrar"
  Então o registro deve falhar
