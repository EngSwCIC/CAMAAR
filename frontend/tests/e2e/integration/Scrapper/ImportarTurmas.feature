#language: pt
Funcionalidade: Importar do SIGAA

    Cenario: Foi possível importar as turmas com participantes do SIGAA
    Dado que estou na rota "/import"
    E eu clicar no botão "Buscar Turmas no SIGAA"
    E eu selecionar a primeira turma
    E eu clicar no botão "Importar para CAMAAR"
    Então eu devo ver na tabela "Turmas Registradas" a primeira turma selecionada

    Cenario: Tentar importar Turmas sem selecionar
    Dado que estou na rota "/import"
    E eu clicar no botão "Buscar Turmas no SIGAA"
    E eu clicar no botão "Importar para CAMAAR sem selecionar uma turma"
    Então eu devo ver uma notificação de "Selecione uma ou mais turmas para importar"

    # This test is not passing yet
    # The backend is receiving empty data and isn't showing
    # any error messages.
    @mockTurmasVazias
    Cenario: Erro ao importar as turmas vazias do SIGAA
    Dado que estou na rota "/import"
    E eu clicar no botão "Buscar Turmas no SIGAA"
    E eu selecionar a primeira turma
    E eu clicar no botão "Importar para CAMAAR"
    Então eu devo ver uma notificação de "Erro"
