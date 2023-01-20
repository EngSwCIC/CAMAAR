Funcionalidade: Importar do SIGAA
Cenario: Foi possível importar as turmas com participantes do SIGAA
Dado que estou na rota "/import"
E eu clicar no botão "Buscar Turmas no SIGAA"
E eu selecionar a primeira turma
E eu clicar em “Importar para CAMMAR”
Eu devo ver na tabela “Turmas Registradas” a primeira turma selecionada

@mockSemParticipantes
Cenario: Erro ao importar as turmas com participantes do SIGAA
Dado que estou na rota "/import"
E eu clicar no botão "Buscar Turmas no SIGAA"
E eu selecionar a primeira turma
E eu clicar em “Importar para CAMMAR”
Eu devo ver uma notificação “Erro ao importar turmas”
E eu não devo ver a primeira turma na tabela “Turmas Registradas”

