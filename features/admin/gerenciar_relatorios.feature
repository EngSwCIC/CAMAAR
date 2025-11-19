# language: pt-br

Funcionalidade: Visualização e Download de Resultados de Avaliação
	Como um administrador
	Eu quero baixar um arquivo CSV contendo os resultados de um formulário
	A fim de avaliar o desempenho das turmas

Cenário: Admin baixa CSV de uma turma com respostas
    Dado que eu estou logado como "admin@sistema.com"
    E eu navego para a página "Gerenciamento"
    E eu clico em "Resultados"
    E eu estou na tela "Gerenciamento - Resultados"
    Quando eu clico no bloco da turma "BANCOS DE DADOS (CIC0097) - Prof. Joao"
    Então eu devo baixar um arquivo chamado "resultados_CIC0097_ProfJoao.csv"
    
Cenário: Admin tenta ver resultados de uma turma sem respostas
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na tela "Gerenciamento - Resultados"
    E a turma "ENGENHARIA DE SOFTWARE (CIC0105) - Prof. Genaina" possui 0 respostas de avaliação
    Quando eu clico no bloco da turma "ENGENHARIA DE SOFTWARE (CIC0105) - Prof. Genaina"
    Então deve exibir a mensagem "Este formulário ainda não possui respostas"
    E não efetuar nenhum download de aruivo CSV.

Cenário: Professor (não-admin) tenta acessar a página de resultados diretamente pela URL
    Dado que eu estou logado como "professor.comum@sistema.com" (que não é admin)
    E eu não vejo o link para a página "Gerenciamento" no meu menu
    Quando eu tento acessar a URL "/gerenciamento/resultados" diretamente no meu navegador
    Então eu devo ser redirecionado para a minha página inicial (ou "Dashboard")