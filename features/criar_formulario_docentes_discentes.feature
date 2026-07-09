# language: pt

#Issue-4

Funcionalidade: Criar formulário para docentes ou discentes
    Como administrador
    Quero definir o público-alvo de um formulário de avaliação
    A fim de garantir que apenas os participantes corretos visualizem e respondam o formulário


    Cenário: [Feliz] Criar formulário com público-alvo definido como discentes
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        E existe um template de formulário cadastrado no sistema
        E existe uma turma do meu departamento disponível para seleção
        Quando crio um formulário com o template selecionado para a turma com público-alvo "Discentes"
        Então o formulário deve ser criado com sucesso
        E o acesso deve estar restrito ao público-alvo "Discentes"

    Cenário: [Feliz] Criar formulário com público-alvo definido como docentes
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        E existe um template de formulário cadastrado no sistema
        E existe uma turma do meu departamento disponível para seleção
        Quando crio um formulário com o template selecionado para a turma com público-alvo "Docentes"
        Então o formulário deve ser criado com sucesso
        E o acesso deve estar restrito ao público-alvo "Docentes"
 
    Cenário: [Feliz] Discente visualiza formulário destinado a discentes
        Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
        E existe um formulário destinado a "Discentes" para a turma "CIC0097 - BANCOS DE DADOS"
        E eu estou matriculado na turma "CIC0097 - BANCOS DE DADOS"
        Quando eu acesso a lista de formulários disponíveis
        Então devo ver o formulário da turma "CIC0097 - BANCOS DE DADOS" na lista

    Cenário: [Triste] Discente não visualiza formulário destinado apenas a docentes
        Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
        E que existe um formulário destinado a "Docentes" para a turma "CIC0097 - BANCOS DE DADOS"
        E eu estou matriculado na turma "CIC0097 - BANCOS DE DADOS"
        Quando eu acesso a lista de formulários disponíveis
        Então não devo ver o formulário da turma "CIC0097 - BANCOS DE DADOS" na lista

    Cenário: [Triste] Docente não visualiza formulário destinado apenas a discentes
        Dado que eu estou logado no sistema CAMAAR com o perfil de "docente" da turma "CIC0097 - BANCOS DE DADOS"
        E que existe um formulário destinado a "Discentes" para a turma "CIC0097 - BANCOS DE DADOS"
        Quando eu acesso a lista de formulários disponíveis
        Então não devo ver o formulário da turma "CIC0097 - BANCOS DE DADOS" na lista

    Cenário: [Triste] Tentar criar um formulário sem definir o público-alvo
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        Quando crio um formulário com o template selecionado para a turma sem público-alvo
        Então o sistema deve exibir a mensagem de erro "Defina o público-alvo do formulário"

    Cenário: [Feliz] Formulário permanece associado à turma após definição do público-alvo
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        Quando crio um formulário com o template selecionado para a turma "CIC0097 - BANCOS DE DADOS" com público-alvo "Discentes"
        Então o formulário deve ser criado com sucesso
        E deve permanecer vinculado à turma "CIC0097 - BANCOS DE DADOS"
