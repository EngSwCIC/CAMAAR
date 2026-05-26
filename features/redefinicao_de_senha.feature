Feature: Redefinicao de Senha a partir do e-mail
  Eu como Usuário
  Quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
  A fim de recuperar o meu acesso ao sistema

  Background:
    Given que existe um usuário cadastrado no sistema
    And que ele já solicitou a troca de senha e recebeu o e-mail com o link de redefinição

  Scenario: Usuario redefine a senha com sucesso utilizando senhas validas e iguais (Happy Path)
    When o usuario acessa o link valido de redefinicao de senha recebido no e-mail
    And informa a nova senha "NovaSenha@123"
    And confirma a nova senha "NovaSenha@123"
    And envia o formulario de redefinicao de senha
    Then o sistema deve atualizar a senha do usuario
    And deve redirecionar o usuario para a tela de login
    And deve permitir o acesso ao sistema com a nova senha

  Scenario: Usuario tenta redefinir a senha informando confirmacao divergente (Sad Path)
    When o usuario acessa o link valido de redefinicao de senha recebido no e-mail
    And informa a nova senha "NovaSenha@123"
    And confirma a nova senha "SenhaErrada@123"
    And envia o formulario de redefinicao de senha
    Then o sistema nao deve atualizar a senha do usuario
    And deve exibir a mensagem de erro "As senhas informadas nao conferem"