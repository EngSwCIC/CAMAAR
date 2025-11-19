# language: pt-br

Funcionalidade: Visualização de resultados de avaliação restrita por departamento

    Como um administrador
    Eu quero gerenciar (ver e avaliar) somente as turmas do departamento ao qual eu pertenço
    A fim de avaliar o desempenho das turmas no semestre atual

Cenário: Admin do CIC vê apenas as turmas do CIC
    Dado que eu estou logado como "admin@sistema.com"
    E sou professor do depatamento "CIC"
    E eu navego para a página "Gerenciamento" e clico em "Resultados"
    E existe uma turma "Bancos de Dados (CIC0097)" que pertence ao departamento "CIC"
    E existe uma turma "CÁLCULO 1 (MAT0025)" que pertence ao departamento "MAT"
    Quando eu olho a lista de turmas na tela "Gerenciamento - Resultados"
    Então eu devo ver o bloco da turma "Bancos de Dados (CIC0097)"
    E eu não devo ver o bloco da turma "CÁLCULO 1 (MAT0025)"

Cenário: Admin do MAT vê apenas as turmas do MAT
    Dado que eu estou logado como "admin@sistema.com"
    E sou professor do depatamento "MAT"
    E eu navego para a página "Gerenciamento" e clico em "Resultados"
    E existe uma turma "Bancos de Dados (CIC0097)" que pertence ao departamento "CIC"
    E existe uma turma "CÁLCULO 1 (MAT0025)" que pertence ao departamento "MAT"
    Quando eu olho a lista de turmas na tela "Gerenciamento - Resultados"
    Então eu não devo ver o bloco da turma "Bancos de Dados (CIC0097)"
    E eu devo ver o bloco da turma "CÁLCULO 1 (MAT0025)"

Cenário: Admin do CIC tenta acessar resultados do MAT diretamente pela URL
    Dado que eu estou logado como "admin@sistema.com"
    E sou professor do depatamento "CIC"
    E existe a turma "Cálculo 1 (MAT0025)" (de id: 42) que pertence ao departamento "MAT"
    Quando eu tento acessar a URL "/gerenciamento/resultados/42" diretamente no meu navegador
    Então eu devo ser redirecionado para a minha página inicial (ou "Dashboard")