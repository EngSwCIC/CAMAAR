# language: pt
Funcionalidade: Redefinição de senha
  Como Usuário do sistema
  Quero redefinir minha senha através de um e-mail recebido após solicitar a troca
  A fim de recuperar o meu acesso ao sistema

  Contexto:
    Dado que o usuário solicitou a redefinição de senha
    E recebeu o e-mail com o link de redefinição

  Cenário: Redefinição de senha bem-sucedida com link válido (Caminho Feliz)
    Dado que o usuário acessa o link de redefinição de senha válido
    E está na página de redefinição de senha
    Quando o usuário preenche o campo "Nova Senha" com "NovaSenha123"
    E preenche o campo "Confirmar Nova Senha" com "NovaSenha123"
    E clica em "Redefinir Senha"
    Então o sistema deve atualizar a senha do usuário
    E exibir a mensagem "Senha redefinida com sucesso"
    E redirecionar o usuário para a página de login

  Cenário: Falha ao tentar redefinir senha com link expirado (Caminho Triste)
    Dado que o usuário acessa um link de redefinição de senha expirado
    Quando o usuário tenta acessar a página de redefinição
    Então o sistema deve bloquear o acesso
    E exibir a mensagem de erro "Link de redefinição inválido ou expirado"
    E apresentar a opção de solicitar um novo link
