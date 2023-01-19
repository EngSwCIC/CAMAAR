#language: pt
Funcionalidade: Refifinição de senha

	Como um aluno
	Para que eu possa me logar
	Eu quero ter a capacidade de redefinir a minha senha

Background:
	Dados que clico no link de redefinição me enviado por email
	Então eu devo ver um campo "Nova Senha"
	E um campo "Confirmar nova senha"

Cenario: Digitar senha diferente no campo de confimação (triste)
	Quando eu selecionar o campo "Nova Senha"
	E digitar "senha123"
	E depois selecionar o campo "Confimar nova senha"
	E digitar "senha_diferente"
	Então devo ver uma mensagem "Senha de confirmação diferente da nova senha"
		
Cenario: Digitar senha válida (feliz)
	Quando eu selecionar o campo "Nova Senha"
	E digitar "senha_valida"
	E depois selecionar o campo "Confimar nova senha"
	E digitar "senha_valida"
	Então devo ver uma mensagem "Senha redefinida com sucesso"