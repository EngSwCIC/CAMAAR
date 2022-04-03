Funcionalidade: Gerar relatório
Eu como aluno 
Quero gerar um relatório PDF a partir da pesquisa realizada 
A fim de ter as informações salvas em um arquivo

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu esteja na página de relatório do aluno
  E que exista um botão "Gerar PDF"
  
Cenario: Um Aluno tenta gerar um relatório no sistema do CAMAAR, mas a pesquisa não retorna dados (triste)
  Dado que a pesquisa não corresponde a nenhuma turma
  Quando eu clicar no botão "Gerar PDF"
  Então eu deveria ver uma mensagem na tela dizendo "Não há dados suficientes"

Cenario: Um Aluno gera um PDF contendo o relatório de acordo com sua pesquisa (feliz)
  Dado que a pesquisa corresponde a uma ou mais turmas
  Quando o aluno  clicar no botão "Gerar PDF"
  Então deve ser gerado um arquivo .PDF com as informações das turmas correspondentes
