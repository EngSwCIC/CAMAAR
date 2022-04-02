Funcionalidade: Gerar relatório
Eu como aluno 
Quero gerar um relatório de usuário 
A fim de exportalo para PDF

  Contexto:
    Dado que eu esteja logado como aluno no CAMAAR
    E eu esteja na página de relatório do aluno

  # Cenario Triste relatório não gerado
  Cenario: Um Aluno tenta gerar um relatório no sistema do CAMAAR e não consegue
  Dado que exista um botão "Gerar PDF" que não esteja funcionando
  Quando eu clicar no botão "Reportar Erro"
  Então deve aparecer uma mensagem na tela dizendo "Email para reportar erros: xxxxxxx@unb.com.br"

  # Cenario Feliz o aluno consegue gerar o relatório com sucesso
  Cenario: Um Aluno tenta gerar um PDF contendo o relatório e consegue
  Dado que exista um botão "Gerar PDF"
  Quando o aluno  clicar no botão "Gerar PDF"
  Então deve ser gerado um PDF para que o aluno possa guardar em seu computador
