Funcionalidade: Gerar relatório
Eu como aluno 
Quero gerar um relatório de usuário 
A fim de armazená-lo no banco de dados do SIGAA

  Contexto:
    Dado que eu esteja logado como aluno no CAMAAR
    E eu esteja na página de relatório do aluno

  # Cenario Triste relatório não gerado
  Cenario: Um Aluno tenta registrar seus dados ao sistema do CAMAAR e não consegue
  Dado que exista um botão "Registrar" que não esteja funcionando
  Quando eu clicar no botão "Reportar Erro"
  Então deve aparecer uma mensagem na tela dizendo "Email para reportar erros: xxxxxxx@unb.com.br"

  # Cenario Feliz o aluno consegue gerar o relatório com sucesso
  Cenario: Um Aluno tenta registrar seus dados ao sistema do CAMAAR e consegue
  Dado que exista um botão "Registrar"
  Quando o aluno  clicar no botão "Registrar"
  Então deve aparecer um mensagem dizendo "Aluno cadastrado"
