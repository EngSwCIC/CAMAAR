#language: pt
Funcionalidade: Redefinição de senha
	Como um aluno
	Para que eu possa me logar
	Eu quero ter a capacidade de redefinir a minha senha

Contexto:
	Dado que nao estou autenticado
	Dado que estou na rota "/#/cadastro/1234"
	Então eu deveria ver o campo "senhanova"
	E eu deveria ver o campo "senhaconfirmacao"

Cenário: Digitar senha diferente no campo de confimação (triste)
	Quando eu selecionar o campo "Nova Senha"
	E digitar "senha123"
	E depois selecionar o campo "Confimar nova senha"
	E digitar "senha_diferente"
	Então devo ver uma mensagem "Senha de confirmação diferente da nova senha"
		
Cenário: Digitar senha válida (feliz)
	Quando eu selecionar o campo "Nova Senha"
	E digitar "senha_valida"
	E depois selecionar o campo "Confimar nova senha"
	E digitar "senha_valida"
	Então devo ver uma mensagem "Senha redefinida com sucesso"
