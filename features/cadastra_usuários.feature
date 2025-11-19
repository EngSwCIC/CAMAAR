# language: pt
#2 pontos

Funcionalidade: Cadastrar usuários do sistema #100 
Eu como Administrador
Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
A fim de que eles acessem o sistema

Contexto:
Dado que o o banco de dados está 'vazio'
E que está na tela 'gerenciamento'
E os dados do SIGAA foram extraidos

@100.1
Cenário: 100.1 - Quando um Administrador tenta registrar novos usuários do Sigaa, deve salvar os novos alunos no banco de dados e enviar emails para cadastrar a senha.

Quando o sistema tenta cadastrar novos usuários
Entao deve caastrar novos alunos no banco de dados
E enviar emails para cadastrar a senha

@100.2
Cenário:  100.2 - Quando um Administrador tenta cadastrar estudantes já cadastrados, o sistema deve retornar uma mensagem informando que não há novos usuários a serem cadastrados.

Quando o sistema tenta inserir os estudantes
E todos os estudantes já existem no banco de dados
Então ele não cadastra nenhum novo usuário
E retorna mensagem informando que não havia novos estudantes para cadastrar.

@100.3
Cenário: 100.3 - Quando um Administrador tenta adicionar novos estudantes mas não existem alunos nos dados do SIGAA deve exibir mensagem indicando que o arquivo está vazio.

Quando um Administrador tenta adicionar novos estudantes
E não há alunos nos dados do SIGAA
Entao deve exibir mensagem de erro 'sigaa_vazio'
