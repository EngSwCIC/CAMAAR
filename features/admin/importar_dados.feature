# language: pt-br
	
Funcionalidade: Alimentação inicial da base de dados com JSON do SIGAA

    Como um administrador
	Eu quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
	A fim de alimentar a base de dados do sistema.

Cenário: Admin importa dados em um sistema vazio
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E o banco de dados não contém nenhuma disciplina ou aluno
    E eu tenho um arquivo "disciplinas_2021.2.json" (com a disciplina "BANCOS DE DADOS")
    E eu tenho um arquivo "turmas_2021.2.json" (com o aluno "Ana Clara Jordao Perna")
    Quando eu seleciono os arquivos "disciplinas_2021.2.json" e "turmas_2021.2.json"
    E importo-os ao sistema
    Então eu devo ver a mensagem "Importação concluída."
    E a disciplina "BANCOS DE DADOS" (CIC0097) deve existir no sistema
    E o aluno "Ana Clara Jordao Perna" (190084006) deve existir no sistema

Cenário: Admin importa dados que já existem na base
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E já existe uma disciplina "BANCOS DE DADOS" (CIC0097) no sistema
    E já existe o aluno "Ana Clara Jordao Perna" (190084006)
    E eu tenho um arquivo "turmas_2021.2_repetido.json" que contém os mesmos dados
    Quando eu seleciono o arquivo "turmas_2021.2_repetido.json"
    E impoto-o ao sistema
    Então eu devo ver a mensagem "Importação concluída."
    E deve haver apenas 1 aluno com a matrícula "190084006" no sistema
    
Cenário: Admin tenta alimentar a base com um arquivo que não é JSON
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E o banco de dados está vazio
    Quando eu seleciono um arquivo "lista_de_alunos.pdf"
    E importo-o ao sistema
    Então devo ver a mensagem de erro "Formato de arquivo inválido. Por favor, envie um arquivo .json."

Cenário: Admin importa JSON de turma com a chave "matricula" faltando
    Dado que eu estou logado como "admin@sistema.com"
    E eu estou na página que contém o botão "Importar dados"
    E eu tenho um arquivo "turmas_sem_matricula.json" onde um "discente" não possui a chave "matricula"
    Quando eu seleciono o arquivo "turmas_sem_matricula.json"
    E importo-o ao sistema
    Então eu devo ver a mensagem de erro "Erro na importação: O arquivo JSON é inválido."
    
    
