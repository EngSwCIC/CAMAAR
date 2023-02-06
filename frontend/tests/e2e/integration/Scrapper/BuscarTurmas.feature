#language: pt
Funcionalidade: Extrair do SIGAA

    Cenario: Foi possível acessar as turmas no SIGAA
    Dado que estou na rota "/import"
    E eu clicar no botão "Buscar Turmas no SIGAA"
    Então eu devo ver na tabela "Importar Turmas" uma ou mais turmas
    
    @mockTurmasVazias
    Cenario: Não Existem turmas cadastradas no SIGAA 
    Dado que estou na rota "/import"
    E eu clicar no botão "Buscar Turmas no SIGAA"
    E a tabela "Importar Turmas" estiver vazia
    Então eu devo ver uma notificação de "Erro ao buscar turmas"