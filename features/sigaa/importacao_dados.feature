# language: pt


Funcionalidade: Importar novos dados do SIGAA
  Eu como Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA
  A fim de alimentar a base de dados do sistema.

  Contexto:
    Dado que eu estou logado como Administrador
    E estou na página "Gerenciamento"

  @happy
  Cenário: Importação inicial de turma e participante com sucesso
    Dado que o sistema não possui nenhuma turma cadastrada
    E que o sistema não possui nenhum usuário cadastrado
    E que o SIGAA contém a turma "BANCOS DE DADOS" (CIC0097)
    E esta turma contém o participante "usuario" (190084006) 
    Quando eu clico no botão "Importar dados"
    Então a turma "BANCOS DE DADOS" (CIC0097) deve ser cadastrada no sistema
    E o usuário "usuario" (190084006) deve ser cadastrado no sistema
    E o usuário "usuario" deve estar matriculado na turma "BANCOS DE DADOS"
    E eu devo ver a mensagem de sucesso "Dados importados com sucesso!"

  @happy
  Cenário: Importação das turmas e matérias de classes.json com sucesso
    Dado que o sistema não possui nenhuma turma cadastrada
    E que o SIGAA contém as turmas "BANCOS DE DADOS" (CIC0097), "ENGENHARIA DE SOFTWARE" (CIC0105) e "PROGRAMAÇÃO CONCORRENTE" (CIC0202)
    Quando eu clico no botão "Importar dados"
    Então as 3 matérias devem ser cadastradas no sistema
    E as 3 turmas devem ser cadastradas no sistema
    E nenhuma matéria ou turma deve ser duplicada
    E eu devo ver a mensagem de sucesso "Dados importados com sucesso!"


  @sad
  Cenário: Falha ao importar dados
    Dado que o SIGAA retorna um arquivo JSON inválido
    Quando eu clico no botão "Importar dados"
    Então eu devo ver a mensagem de erro "Os dados recebidos do SIGAA são inválidos."
    E nenhuma nova turma deve ser cadastrada no sistema
    E nenhum novo usuário deve ser cadastrado no sistema

