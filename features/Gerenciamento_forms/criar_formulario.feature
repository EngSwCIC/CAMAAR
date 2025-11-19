    Funcionalidade: Criar formulário de avaliação
        Eu como Administrador
        Quero criar um formulário baseado em um template para as turmas que eu escolher
        A fim de avaliar o desempenho das turmas no semestre atual

    Cenário: Criar formulário de avaliação para turmas selecionadas
        Dado que eu estou logado como Administrador
        E que eu tenho acesso ao template de formulário "Avaliação Semestral"
        Quando eu seleciono as turmas "Turma A", "Turma B" e "Turma C"
        E eu escolho o template "Avaliação Semestral"
        E eu clico em "Criar Formulário"
        Então o sistema deve criar formulários de avaliação para as turmas selecionadas
        E eu devo ver uma mensagem de sucesso "Formulários criados com sucesso para as turmas selecionadas."

    Cenário: Tentativa de criação sem selecionar turmas
        Dado que eu estou logado como Administrador
        E que existe um template de formulário chamado "Avaliação Semestral"
        Quando eu escolho o template "Avaliação Semestral"
        E eu clico em "Criar Formulário"
        Então eu devo ver uma mensagem de erro "Nenhuma turma selecionada."
        E nenhum formulário deve ser criado

    Cenário: Tentativa de criação sem selecionar template
        Dado que eu estou logado como Administrador
        E que existem turmas cadastradas no sistema
        Quando eu seleciono as turmas "Turma A" e "Turma B"
        E eu clico em "Criar Formulário"
        Então eu devo ver uma mensagem de erro "Nenhum template selecionado."
        E nenhum formulário deve ser criado

