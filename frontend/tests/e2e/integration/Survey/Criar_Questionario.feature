#language: pt
Funcionalidade: Criar template de Questionario com listas de perguntas
(Eu como coordenador
quero clicar em botão
a fim de criar um questionário)

Contexto:
  Dado que eu esteja na página de questionários

Cenario: Um Coordenador deseja criar um questionário (feliz)
  Entao eu deveria ver o campo "Nome do questionário"
  E eu deveria ver o campo "Descrição do Questionário"
  E eu deveria ver o campo "Data de Expiração do Questionário"
  E eu deveria ver o campo "Selecione o semestre"
  E eu deveria ver o campo "Selecione o tipo da questão"
  E eu deveria ver o campo "Opcional"
  E eu deveria ver o campo "Escreva o enunciado"
  E eu deveria ver o botão "Adicionar questão"
  E eu deveria ver o botão "Cancelar"
  E eu deveria ver o botão "Finalizar questionário"

# Contexto:
#   Dado que eu esteja logado como coordenador no CAMAAR
#   E eu esteja na página de criação de questionários:

# Cenario: Um Coordenador deseja criar um questionário (triste)
#   Quando eu clico na seleção de disciplina por id
#   E eu não vejo opções de disciplina
#   E eu não consigo selecionar uma disciplina
# 	Então eu não devo conseguir criar o questionário

# Cenario: Um Coordenador deseja criar um questionário (triste)
#   Quando eu clico na seleção de disciplina por id
#   E eu consigo selecionar uma disciplina
#   E eu não consigo selecionar uma turma
# 	Então eu não devo conseguir criar o questionário

# Cenario: Um Coordenador deseja criar um questionário (triste)
#   Quando eu clico na seleção de disciplina por id
#   E eu consigo selecionar uma disciplina
#   E eu consigo selecionar uma turma
# 	E eu não adiciono perguntas
# 	E eu clico em finalizar criação
# 	Então eu devo ver uma modal de erro

# Cenario: Um Coordenador deseja criar um questionário (triste)
#   Quando eu clico na seleção de disciplina por id
#   E eu consigo selecionar uma disciplina
#   E eu consigo selecionar uma turma
# 	E eu adiciono perguntas
# 	E eu clico em finalizar criação
#   E a operação no backend incorre em erro
# 	Então eu devo ver uma modal de erro

# Cenario: Um Coordenador deseja criar um questionário (feliz)
#   Quando eu clico na seleção de disciplina por id
#   E eu seleciono uma disciplina
#   E eu seleciono uma turma
#   E eu adiciono perguntas
#   E eu clico em finalizar
#   Então eu devo ver uma modal de erro
