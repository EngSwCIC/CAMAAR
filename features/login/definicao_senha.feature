Funcionalidade: Definição inicial de senha
	Como um Usuário
	Eu quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
	A fim de acessar o sistema

Cenário: Usuário define uma senha válida pela primeira vez (Caminho Feliz)
    Dado que eu acessei a página "Definir Senha" através de um link de cadastro válido
    Quando eu preencho o campo "Nova Senha" com "SenhaForte@123"
    E eu preencho o campo "Confirmar Senha" com "SenhaForte@123"
    E eu clico no botão "Definir Senha"
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem "Senha definida com sucesso! Você já pode fazer o login."

Cenário: Usuário tenta definir senhas que não são idênticas (Caminho Triste)
    Dado que eu acessei a página "Definir Senha" através de um link de cadastro válido
    Quando eu preencho o campo "Nova Senha" com "SenhaForte@123"
    E eu preencho o campo "Confirmar Senha" com "SenhaDiferente@123"
    E eu clico no botão "Definir Senha"
    Então eu devo continuar na página "Definir Senha"
    E eu devo ver a mensagem de erro "As senhas não conferem."
    
Cenário: Usuário tenta definir uma senha muito curta (Caminho Triste)
    Dado que eu acessei a página "Definir Senha" através de um link de cadastro válido
    Quando eu preencho o campo "Nova Senha" com "123"
    E eu preencho o campo "Confirmar Senha" com "123"
    E eu clico no botão "Definir Senha"
    Então eu devo continuar na página "Definir Senha"
    E eu devo ver a mensagem de erro "A senha deve ter no mínimo 8 caracteres."

Cenário: Usuário tenta definir uma senha fraca (Caminho Triste)
    Dado que eu acessei a página "Definir Senha" através de um link de cadastro válido
    Quando eu preencho o campo "Nova Senha" com "SenhaFraca"
    E eu preencho o campo "Confirmar Senha" com "SenhaFraca"
    E eu clico no botão "Definir Senha"
    Então eu devo continuar na página "Definir Senha"
    E eu devo ver a mensagem de erro "Não atende aos requisitos mínimos: mínimo 8 caracteres, sendo obrigatório 1 caractere especial, 1 número, 1 letra maiúscula e 1 letra minúscula!"
