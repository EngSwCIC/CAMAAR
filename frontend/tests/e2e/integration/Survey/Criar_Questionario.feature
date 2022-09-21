#language: pt
Funcionalidade: Criar template de Questionario com listas de perguntas
  Eu como coordenador
  quero clicar em botão
  a fim de criar um questionário

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E que eu esteja na página de questionários

Cenario: Um Coordenador deseja criar um questionário (feliz)
  Entao eu deveria ver o campo "Nome_do_questionário"
  E eu deveria ver o campo "Descrição_do_Questionário"
  E eu deveria ver o campo "Data_de_Expiração_do_Questionário"
  E eu deveria ver o campo "Selecione_o_semestre"
  E eu deveria ver o campo "Selecione_o_tipo_da_questão"
  E eu deveria ver o campo "Opcional"
  E eu deveria ver o campo "Escreva_o_enunciado"
  E eu deveria ver o botão "Adicionar_questão"
  E eu deveria ver o botão "Cancelar"
  E eu deveria ver o botão "Finalizar_questionário"

Cenario: Um Coordenador deseja dar nome à um questionário (feliz)
  E eu consigo escrever 'Nome' no campo "Nome_do_questionário"
	E eu devo ver 'Nome' no campo "Nome_do_questionário"

Cenario: Um Coordenador deseja dar nome à um questionário (feliz)
  E eu consigo escrever "Descrição" no campo "Descrição_do_Questionário"
	E eu devo ver "Descrição" no campo "Descrição_do_Questionário"
  E eu deveria selecionar o semestre

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
