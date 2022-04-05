Funcionalidade: Edição de questionário já preenchido
  Eu como aluno
  Quero clicar em um questionário que já respondi
  A fim de editar minhas respostas

Contexto: o questionário foi preenchido anteriormente
  Dado que eu esteja logado como aluno no CAMAAR
  E eu eu vou para a rota "/surveys"
  E que eu já tenha preenchido o questionário

# Happy path
Cenário: Editar a resposta do questionário
  Quando que eu clico no botão "Editar" em "Questionário de fim de semestre"
  Então eu devo ser redirecionado para a rota "/surveys/final"
  E eu devo ver minhas respostas "Condições de estudo"
  E eu devo ver minhas respostas "Ensino remoto vs presencial"
  E eu devo ver minhas respostas "Condições funcionais e de saúde"
  E eu devo ver minhas respostas "Preferências por atividades síncronas e assíncronas"
  E eu devo ver minhas respostas para cada disciplina

# Happy path
Cenário: Adicionar disciplina
  Dado que eu cliquei no botão "Editar" em "Questionário de fim de semestre"
  Quando eu clicar no botão "Adicionar disciplina"
  E selecionar a disciplina "CIC0003 - ENGENHARIA DE SOFTWARE (GRADUAÇÃO) - Turma A - GENAINA NUNES RODRIGUES"
  Então deve ser gerado um novo formulário de disciplina

# Sad path
Cenário: Enviar o questionário editado incorretamente
  Dado que eu cliquei no botão "Editar" em "Questionário de fim de semestre"
  E que eu não tenha preenchido todos os campos obrigatórios
  Quando eu clicar no botão "Atualizar"
  Então eu deveria ver uma mensagem de "Erro"

# Happy path
Cenário: Enviar o questionário editado corretamente
  Dado que eu cliquei no botão "Editar" em "Questionário de fim de semestre"
  E que eu tenha preenchido todos os campos obrigatórios
  Quando eu clicar no botão "Atualizar"
  Então eu deveria ver uma mensagem de "Sucesso"

