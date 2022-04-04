# language: pt
# encoding: utf-8

Funcionalidade: Cadastrar professores do sistema
  Eu como Administrador
  Quero cadastrar professores do CIC
  A fim de que eles acessem o sistema CAMAAR

Contexto:
  Dado que eu esteja na página de registro de professor

Cenário: Registrar com campos válidos (happy path)
  Quando eu escrever "nome" no campo nome
  E eu escrever "departamento" no campo departamento
  E eu escrever "formacao" no campo formacao
  E eu escrever "joe" no campo usuario
  E eu escrever "joe@example.com" no campo email
  E eu clicar em "registrar"
  Então o registro deve suceder

Cenário: Registrar com campos inválidos (sad path)
  Quando eu escrever "" no campo nome
  E eu escrever "" no campo departamento
  E eu escrever "" no campo formacao
  E eu escrever "" no campo usuario
  E eu escrever "" no campo email
  E eu clicar em "registrar"
  Então o registro deve falhar
