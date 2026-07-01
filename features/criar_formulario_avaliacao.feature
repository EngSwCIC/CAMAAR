# language: pt

#Issue-14

Funcionalidade: Criar formulário de avaliação
    Como administrador
    Quero criar um formulário de avaliação a partir de um template
    A fim de enviá-lo para as turmas do meu departamento responderem

    Contexto:
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        E eu acesso a página de criação de formulários de avaliação

    Cenário: [Feliz] Criar um formulário de avaliação com template e turma selecionados
        Dado o template "Avaliação Docente 2024.1" está cadastrado no sistema
        E a turma "CIC0097 - BANCOS DE DADOS" pertence ao meu departamento
        E o formulário possui um público-alvo definido
        Quando crio um formulário com o template "Avaliação Docente 2024.1" para a turma "CIC0097 - BANCOS DE DADOS"
        Então o formulário deve ser criado com sucesso
        E deve estar vinculado à turma "CIC0097 - BANCOS DE DADOS"
        E deve conter as questões do template "Avaliação Docente 2024.1"

    Cenário: [Feliz] Criar um formulário de avaliação vinculado a múltiplas turmas
        Dado o template "Avaliação Semestral" está cadastrado no sistema
        E as turmas "CIC0097 - BANCOS DE DADOS", "CIC0105 - ENGENHARIA DE SOFTWARE" e "CIC0202 - PROGRAMAÇÃO CONCORRENTE" pertencem ao meu departamento
        E o formulário possui um público-alvo definido
        Quando crio um formulário com o template "Avaliação Semestral" para as turmas "CIC0097 - BANCOS DE DADOS", "CIC0105 - ENGENHARIA DE SOFTWARE" e "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
        Então o formulário deve ser criado com sucesso
        E deve estar vinculado às turmas "CIC0097 - BANCOS DE DADOS", "CIC0105 - ENGENHARIA DE SOFTWARE" e "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
        E deve conter as questões do template "Avaliação Semestral"

    Cenário: [Triste] Tentar criar um formulário sem selecionar um template
        Dado a turma "CIC0097 - BANCOS DE DADOS" pertence ao meu departamento
        Quando crio um formulário sem template para a turma "CIC0097 - BANCOS DE DADOS"
        Então o sistema deve exibir a mensagem de erro "Selecione um template para criar o formulário"

    Cenário: [Triste] Tentar criar um formulário sem selecionar nenhuma turma
        Dado o template "Avaliação Docente 2024.1" está cadastrado no sistema
        Quando crio um formulário com o template "Avaliação Docente 2024.1" sem turma
        Então o sistema deve exibir a mensagem de erro "Selecione ao menos uma turma para criar o formulário"

    Cenário: [Triste] Administrador tenta selecionar uma turma de outro departamento
        Dado o template "Avaliação Docente 2024.1" está cadastrado no sistema
        E a turma "MAT0026 - CÁLCULO 1" não pertence ao meu departamento
        Quando tento selecionar a turma "MAT0026 - CÁLCULO 1" no formulário
        Então a turma "MAT0026 - CÁLCULO 1" não deve estar disponível para seleção

    Cenário: [Triste] Participante tenta acessar a página de criação de formulários
        Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
        Quando eu tento acessar a página de criação de formulários de avaliação
        Então o sistema deve exibir a mensagem "Você não tem permissão para acessar esta página"
        E eu devo ser redirecionado para a página inicial do meu perfil
