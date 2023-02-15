#language: pt
Funcionalidade: Criar média das notas dadas pelos alunos

Cenario: Ver a média das avaliações de uma determinada turma 
Dado que estou na rota de /students-subjects (página de avaliação dos alunos)
E ao entrar em um questionário de uma turma
E ver as avaliacoes individuais de cada aluno
Então devo conseguir observar a media das avaliações dadas pelos alunos

@mockBaixaAdesaoDeNotas
Cenario: Apenas um aluno fez a avaliação 
Dado que estou na rota de /students-subjects (página de avaliação dos alunos) 
E ao exibir as avaliações de uma turma
E o numero de avaliações for <= 1
Então não preciso mostrar a média 
