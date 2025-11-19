# language: pt-br

Funcionalidade: Atualização da base de dados por importação de JSON do SIGAA

	Como um administrador do sistema
	Eu quero fazer o upload de um (ou mais) arquivo JSON contendo os dados das disciplinas, turmas e alunos matriculados
	A fim de atualizar o sistema com as turmas do semestre e garantir que apenas os alunos corretos possam avaliar seus respectivos professores.

Cenário: Admin importa JSON de um novo semestre
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E eu tenho os arquivos "disciplinas_2021.2.json" e "turmas_2021.2.json"
    Quando eu seleciono os arquivos "disciplinas_2021.2.json" e "turmas_2021.2.json"
    E importo-os para o sistema
    Então eu devo ver a mensagem "Importação concluída."
    E a disciplina "BANCOS DE DADOS" (CIC0097) deve existir no sistema
    E a aluna "Ana Clara Jordao Perna" (190084006) deve estar matriculada na turma "TA" de "CIC0097"
    
    
Cenário: Admin importa JSON que atualiza o email de um aluno
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E existe uma aluna "Ana Clara Jordao Perna" (190084006) com o email "acjpjvjp@gmail.com"
    E eu tenho um arquivo "turmas_correcao.json" onde o aluno "190484006" agora tem o email "ana.clara@aluno.unb.br"
    Quando eu seleciono o arquivo "turmas_correcao.json"
    E importo-o ao sistema
    Então eu devo ver a mensagem "Importação concluída."
    E a aluna (190084006) deve ter o email "ana.clara@aluno.unb.br" no banco de dados
    E não deve existir um novo aluno no sistema
    
Cenário: Admin tenta importar um arquivo que não é JSON
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    Quando eu seleciono um arquivo "documento.csv" para importaçao de dados
    E importo-o ao sistema
    Então eu devo continuar na página que contém o botão "Importar dados"
    E eu devo ver a mensagem de erro "Formato de arquivo inválido. Por favor, envie um arquivo .json."
    
Cenário: Admin importa JSON de turma com chave "matricula" faltando
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E eu tenho um arquivo "turmas_sem_matricula.json" onde um objeto "discente" não possui a chave "matricula"
    Quando eu seleciono o arquivo "turmas_sem_matricula.json" para importação de dados
    E importo-o ao sistema
    Então eu devo continuar na página que contém o botão "Importar dados"
    E eu devo ver a mensagem de erro "Erro na importação: O arquivo JSON é inválido."
    
    
Cenário: Admin importa um arquivo JSON com sintaxe quebrada
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E eu tenho um arquivo "json_errado.json" (que possui um erro de sintaxe, como uma vírgula extra)
    Quando eu seleciono o arquivo "json_errado.json" para importação de dados
    E importo-o ao sistema
    Então eu devo continuar na página que contém o botão "Importar dados"
    E eu devo ver a mensagem de erro "Erro: O arquivo não é um JSON válido."


Cenário: Admin importa JSON com tipo de dado inválido para matrícula
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E eu tenho um arquivo "turmas_tipo_errado.json" onde a "matricula" de um aluno é o texto "matricula" em vez de um número
    Quando eu seleciono o arquivo "turmas_tipo_errado.json" para importação de dados
    E importo-o ao sistema
    Então eu devo continuar na página que contém o botão "Importar dados"
    E eu devo ver a mensagem de erro "Erro na importação."