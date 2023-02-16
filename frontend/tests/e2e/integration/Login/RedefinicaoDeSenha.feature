#language: pt
Funcionalidade: Redefinição de senha
	Como um aluno
	Para que eu possa me logar
	Eu quero ter a capacidade de redefinir a minha senha

Contexto:
	Dado que estou na pagina de redefinicao de senha
	Então eu deveria ver o campo "senhanova"
	E eu deveria ver o campo "senhaconfirmacao"
	E eu deveria ver o campo "senhaantiga"

Cenário: Digitar senha antiga inválida (triste)
	Quando eu selecionar o campo senhaantiga e digitar "1234567"
	E selecionar o campo senhanova e digitar "12345678"
	E selecionar o campo senhaconfirmacao e digitar "12345678"
	E eu clicar no botão "registrar"
	Então devo ver uma mensagem "Invalid Email or password."
		
Cenário: Digitar senha válida (feliz)
	Quando eu selecionar o campo senhaantiga e digitar "123456789"
	E selecionar o campo senhanova e digitar "123456789"
	E selecionar o campo senhaconfirmacao e digitar "123456789"
	E eu clicar no botão "registrar"
	Então devo ver uma mensagem "Cadastrado com sucesso"


