# language: pt

@Issue-17

Funcionalidade: Cadastrar usuários do sistema
    Eu como Administrador
    Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos para o sistema
    A fim de que eles acessem o sistema CAMAAR

    Cenário: [Feliz] Cadastrar usuário com dados válidos
        Dado que eu estou logado no sistema com o perfil de "administrador"
        E que eu acesso a opção de "Gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo JSON contendo os dados de novos usuários do SIGAA
        E os dados estão válidos no arquivo importado 
        Então o sistema deve processar o arquivo e criar solicitações de definição de senha para cada usuário novo
        E os usuários devem receber um e-mail com um link para definir suas senhas

    Cenário: [Feliz] Usuário permanece pendente enquanto não define a senha
        Dado que um usuário foi cadastrado com sucesso no sistema e recebeu um e-mail para definir a senha
        E o usuário ainda não definiu sua senha
        Então o sistema deve manter o status do usuário como "pendente"
        E o usuário não deve ter acesso ao sistema até que a senha seja definida

    Cenário: [Feliz] Usuário define a senha e é ativado
        Dado que um usuário foi cadastrado com sucesso no sistema e recebeu um e-mail para definir a senha
        E o usuário definiu sua senha
        Então o sistema deve atualizar o status do usuário para "ativo"
        E o usuário deve conseguir acessar o sistema com suas credenciais

    Cenário: [Triste] Tentar cadastrar usuário com dados inválidos
        Dado que estou logado no sistema com o perfil de "administrador"
        E que eu acesso a opção de "Gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo JSON contendo os dados de novos usuários
        E os dados estão inválidos no arquivo importado
        Então o sistema deve exibir uma mensagem de erro "Erro: Dados inválidos"
        E o sistema não deve criar solicitações de definição de senha para os usuários 

    Cenário: [Triste] Tentar cadastrar usuário já existente
        Dado que estou logado no sistema com o perfil de "administrador"
        E que eu acesso a opção de "Gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo JSON contendo os dados de novos usuários
        E os dados estão válidos mas correspondem a usuários já existentes no sistema
        Então o sistema deve exibir uma mensagem de aviso "Aviso: Usuário já existe"
        E o sistema não deve criar solicitações de definição de senha para os usuários duplicados