Feature: Sistema de Login
    Eu como Usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

  Background:
    Given que a página de login do sistema está disponível para acesso

  Scenario: Autenticação bem-sucedida de um administrador com exibição do menu de gerenciamento
    Given que existe um administrador registrado com o e-mail "coordenador@unb.br" e senha "Coord@2024"
    When o usuário preenche o campo de identificação com "coordenador@unb.br"
    And preenche o campo de senha com "Coord@2024"
    And aciona o botão "Entrar"
    Then o sistema deve autenticar o usuário com sucesso
    And redirecionar para a página inicial do sistema
    And a opção "Gerenciamento" deve estar visível no menu lateral

  Scenario: Tentativa de login com credenciais não reconhecidas pelo sistema
    Given que o sistema não possui nenhum cadastro com a matrícula "999999999"
    When o usuário preenche o campo de identificação com "999999999"
    And preenche o campo de senha com "qualquerSenha"
    And aciona o botão "Entrar"
    Then o sistema deve recusar o acesso
    And exibir a mensagem "Identificação ou senha inválidos. Verifique suas credenciais e tente novamente."
    And o usuário deve permanecer na página de login
