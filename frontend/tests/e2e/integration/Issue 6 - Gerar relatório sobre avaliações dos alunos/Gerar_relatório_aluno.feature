Funcionalidade: Gerar relatório de acompanhamento de turmas.
Eu como aluno 
Quero gerar um relatório de turmas 
A fim de acompanhar as turmas

  Contexto:
    Dado que eu esteja logado como aluno no CAMAAR
    E eu esteja na página de relatório de turmas

  # Cenario Triste relatório não gerado
  Cenario: Um Aluno tenta registrar seus dados ao sistema do CAMAAR e não consegue
  Dado que exista um botão "Registrar" que não esteja funcionando
  Quando eu clicar no botão "Reportar Erro"
  Então deve aparecer uma mensagem na tela dizendo "Email para reportar erros: xxxxxxx@unb.com.br"

  # Cenario Feliz o aluno consegue gerar o relatório com sucesso
  Cenario: Um Aluno tenta gerar relatório 
  Dado que exista um botão "Gerar relatório"
  Quando o aluno  clicar no botão "Gerar relatório"
  Então deve aparecer um mensagem dizendo "Relatório gerado"