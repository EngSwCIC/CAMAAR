Funcionalidade: Redefinição de senha
	Como um Usuário
	Eu quero redefinir uma senha para o meu usuário a partir do e-mail recebido
	A fim de recuperar o meu acesso ao sistema

Cenário: Usuário solicita redefinição com e-mail válido (Caminho Feliz)
    Dado que eu estou na página de "Login"
    E existe um usuário cadastrado com o e-mail "usuario_valido@alias"
    Quando eu clico no link "Esqueci minha senha"
    E eu preencho o campo "E-mail" com "usuario_valido@alias"
    E clico no botão "Solicitar redefinição"
    Então eu devo ver a mensagem "Um e-mail de redefinição foi enviado para sua caixa de entrada."
    E um e-mail com um link de redefinição deve ser enviado para "usuario_valido@alias"

Cenário: Usuário solicita redefinição com e-mail não cadastrado (Caminho Triste)
    Dado que eu estou na página de "Login"
    E não existe um usuário cadastrado com o e-mail "usuario_valido@alias"
    Quando eu clico no link "Esqueci minha senha"
    E eu preencho o campo "E-mail" com "usuario_valido@alias"
    E clico no botão "Solicitar redefinição"
    Então eu devo ver a mensagem "Se este e-mail estiver cadastrado, um link será enviado."
    E nenhum e-mail de redefinição deve ser enviado
