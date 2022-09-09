#language: pt
Funcionalidade: Verificação do código de validação
  
  Como um aluno pré-cadastrado
  Para que eu possa avaliar as disciplinas
  Eu quero validar meu cadastro

Background:
  Dados que estou na página de validação
  Então eu devo ver "Insira código de validação"

  Cenario: Código inválido (triste)
    Quando eu preencher o campo com o um código
    E eu apertar "Validar código"
    E o código não está associado a nenhum usuário pré-cadastrado
    Então eu deveria ver "Código inválido"


  Cenario: Código válido (feliz)
    Quando eu preencher o campo com um código
    E eu apertar "Validar código"
    E o código está asssociado a um usuário com pré-cadastrado 
    Então eu devo ver a Pagina de Cadastro
