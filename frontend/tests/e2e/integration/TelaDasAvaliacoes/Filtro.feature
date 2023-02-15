#language: pt
Funcionalidade: Buscar por respostas de questionarios

Cenario: Buscar por turmas
Dado que estou na rota de /students-subjects (pagina de avaliação dos alunos)
E digitar nome ou codigo da disciplina no campo de filtro
Então devo ver as turmas que possuem esses parametros

@mockTurmaNaoExiste
Cenario: Buscar pelas respostas de uma turma
Dado que estou na rota de /students-subjects (pagina de avaliação dos alunos)
E digitar nome ou codigo da disciplina que não existem
E não retornar nenhuma turma na tabela
Então eu devo ver uma notificação de "A turma que está procurando não existe"
