# encoding : UTF-8
# language: pt

Funcionalidade: Cadastrar usuários do sistema
        Eu, como Administrador
        Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
        A fim de que eles acessem o sistema CAMAAR

  Cenário: Cadastro de usuário importado do SIGAA (happy path)
    Dado que estou na página de gerenciamento 
    Dado que eu importei os dados do SIGAA com sucesso
    Então o e-mail de usuário "usuario@teste.com" está cadastrado no sistema com senha indefinida
    E um email de definição de senha é enviado para o email "usuario@teste.com"