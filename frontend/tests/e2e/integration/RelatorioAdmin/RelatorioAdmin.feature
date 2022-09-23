#language: pt
Funcionalidade: Gerar Relatório das notas para o Admin

Cenario: Um usuário não admin tenta acessar o Relatório
Dado que estou na rota "/admin/relatorio"
Então eu deveria ser redirecionado para a página de login

@logged
Cenario: Um usuário admin acessa após o lançamento das informações
Dado que estou na rota "/admin/relatorio"
Então eu deveria ver "as médias das turmas", dispostas em formato de tabela

@logged
@noReportData
Cenário: Um admin acessa antes do lançamento das notas
Dado que estou na rota "/admin/relatorio"
Então devo ver uma mensagem de "não há dados aqui ainda"
