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

Cenario: Um Coordenador deseja adicionar as informações básicas do questionário (feliz)
  E eu consigo escrever 'Nome' no campo "Nome_do_questionário"
  E eu consigo escrever "Descrição" no campo "Descrição_do_Questionário"
  E eu consigo escolher uma data
  E eu deveria selecionar o semestre
	E eu devo ver 'Nome' no campo "Nome_do_questionário"
	E eu devo ver "Descrição" no campo "Descrição_do_Questionário"
  E eu devo ver o semestre selecionado

Cenario: Um Coordenador deseja adicionar uma pergunta discursiva ao questionário (feliz)
  E eu deveria selecionar o tipo de pergunta "Discursiva" 
  E eu deveria marcar o campo de "Opcional"
  E eu consigo escrever 'Enunciado' no campo "Escreva_o_enunciado"
  E eu devo apertar o botão "Adicionar_questão"
  E eu deveria ver uma questão com os campos de "Opcional" e "Discursiva" e "Enunciado"

Cenario: Um Coordenador deseja adicionar uma pergunta de escala ao questionário (feliz)
  E eu deveria selecionar o tipo de pergunta "Escala"
  E eu deveria marcar o campo de "Opcional"
  E eu consigo escrever 'Enunciado' no campo "Escreva_o_enunciado"
  E eu devo apertar o botão "Adicionar_questão"
  E eu deveria ver uma questão com os campos de "Opcional" e "Escala" e "Enunciado"

Cenario: Um Coordenador deseja criar um questionário (triste)
  E eu deveria selecionar o tipo de pergunta "Discursiva"
  Dado que eu não escrevo nos campos necessários
  E eu devo apertar o botão "Adicionar_questão"
	Então eu deveria ver um modal de erro

