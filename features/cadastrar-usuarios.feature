# language: pt

Funcionalidade: Cadastrar usuário
    Eu como Administrador
    Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
    A fim de que eles acessem o sistema CAMAAR


    # Happy Paths

    Cenário: Sucesso na resposta de formulário
        Dado que eu estou logado no sistema como Administrador
        E que estou na página de gerenciamento
        E que selecionei uma matéria
        Quando eu clicar no botão de convidar alunos
        O sistema enviará um email para todo aluno da turma
        E mostrará uma mensagem de sucesso ao Administrador

    # Sad Paths

    Cenário: aluno já tem contaconta no CAAMAR
        Dado que eu estou logado no sistema como Administrador
        E que estou na página de gerenciamento
        E que selecionei uma matéria
        Quando eu clicar no botão de convidar alunos
        Um aluno já está cadastrado
        Mostrará uma mensagem ao adminstrador com informando os alunos que já foram cadastradados