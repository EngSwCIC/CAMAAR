#language: pt
Funcionalidade: Verificação do código de validação
  
  Como um aluno querendo se cadastrar
  Para que eu possa avaliar as disciplinas
  Eu quero validar meu cadastro

Background:
  Dados que estou na página de validação
  Então eu devo ver "Insira código de validação"

  Cenario: Código inválido (triste)
    Quando eu preencher o campo com o "00000"
    E eu apertar "Validar código"
    Então eu devo estar na página de validação
    E eu deveria ver "Código de validação inválido"


  Cenario: Código válido (feliz)
    Quando eu preencher o campo com o "12345"
    E eu apertar "Validar código"
    Então eu devo estar na página inicial logada