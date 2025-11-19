Funcionalidade: Cadastro de usuários do SIGAA via importação de dados
	Como um Administrador
	Eu quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos
	A fim de que eles acessem o sistema CAMAAR

Cenário: Admin importa JSON com um novo aluno (Caminho Feliz)
    Dado que eu estou logado como "admin_valido@alias"
    E eu estou na página que contém o botão "Importar dados"
    E o banco de dados não contém o aluno "Novo Aluno" (matrícula "200012345")
    E eu tenho um arquivo "turmas_novo_aluno.json" que contém "Novo Aluno" (200012345) com o email "novo.aluno@alias"
    Quando eu seleciono o arquivo "turmas_novo_aluno.json"
    E importo-o ao sistema
    Então eu devo ver a mensagem "Importação concluída."
    E o aluno "Novo Aluno" (200012345) deve existir no sistema com status "Pendente"
    E um e-mail de definição de senha deve ser enviado para "novo.aluno@alias"

Cenário: Admin importa JSON com um novo professor (Caminho Feliz)
    Dado que eu estou logado como "admin_valido@alias"
    E eu estou na página que contém o botão "Importar dados"
    E o banco de dados não contém o professor "Novo Professor" (matrícula "XXXXXXXXX")
    E eu tenho um arquivo "departamento_novo_professor.json" que contém "Novo Professor" (XXXXXXXXX) com o email "novo.professor@alias"
    Quando eu seleciono o arquivo "departamento_novo_professor.json"
    E importo-o ao sistema
    Então eu devo ver a mensagem "Importação concluída."
    E o professor "Novo Professor" (XXXXXXXXX) deve existir no sistema com status "Pendente"
    E um e-mail de definição de senha deve ser enviado para "novo.professor@alias"

Cenário: Admin importa JSON de turma com aluno novo sem a chave "email" (Caminho Triste)
    Dado que eu estou logado como "admin_valido@alias"
    E eu estou na página que contém o botão "Importar dados"
    E eu tenho um arquivo "turmas_sem_email.json" onde um "discente" novo não possui a chave "email"
    Quando eu seleciono o arquivo "turmas_sem_email.json"
    E importo-o ao sistema
    Então eu devo ver a mensagem de erro "Erro na importação: O arquivo JSON é inválido."
    E nenhum novo usuário deve ser criado
