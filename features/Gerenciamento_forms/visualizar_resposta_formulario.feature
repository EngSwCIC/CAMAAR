    Funcionalidade: Visualização de resultados dos formulários
        Eu como Administrador
        Quero visualizar os formulários criados
        A fim de poder gerar um relatório a partir das respostas
    
    Cenário: Visualizar formulários criados para turmas selecionadas
        Dado que eu estou logado como Administrador
        E que eu tenho formulários criados para as turmas "Turma A" e  "Turma B"
        Quando eu acesso a seção de formulários criados
        Então eu devo ver os formulários criados para "Turma A" e "Turma B"
        E eu devo ver uma mensagem indicando o número de formulários criados "Existem 2 formulários criados."                     s

    Cenário: Visualizar detalhes de um formulários
        Dado que eu estou logado como Administrador
        E que existe um formulário criado para a turma "Turma A"
        Quando eu seleciono o formulário de "Turma A" na lista
        Então eu devo visualizar as perguntas, respostas e estatísticas do formulário
