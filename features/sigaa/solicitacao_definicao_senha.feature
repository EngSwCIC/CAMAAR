  # language: pt

Funcionalidade: Solicitar definição de senha
Eu como Administrador
Quero solicitar meus usuários a criar uma senha para novos usuário
A fim de conseguir que todos meus usuário possam logar

@happy
Cenário: Solicitar definição de senha para usuários novos importados
  Dado que o sistema possui a turma "BANCOS DE DADOS" (CIC0097) cadastrada
  E que o sistema não possui o usuário "usuario" (190084006) cadastrado
  E que o SIGAA contém o participante "usuario" (190084006) na turma "BANCOS DE DADOS" (CIC0097)
  Quando eu clico no botão "Solicitar definição de senha"
  Então o usuário "usuario" (190084006) deve estar pendente de definição de senha
  E o usuário "usuario" (190084006) não deve possuir senha definida
  E eu devo ver a mensagem de sucesso "Dados importados com sucesso!"
@sad
  Cenário: Falha ao solicitar definição de senha para participante sem e-mail no SIGAA
    Dado que o sistema possui a turma "BANCOS DE DADOS" (CIC0097) cadastrada
    E que o sistema não possui o usuário "Participante Sem E-mail" (199999999) cadastrado
    E que o SIGAA contém o participante "Participante Sem E-mail" (199999999) na turma "BANCOS DE DADOS" (CIC0097) sem e-mail cadastrado
    Quando eu clico no botão "Importar dados"
    Então o usuário "Participante Sem E-mail" (199999999) não deve ser cadastrado no sistema
    E nenhuma solicitação de definição de senha deve ser enviada
    E eu devo ver a mensagem de erro "Não foi possível solicitar a definição de senha: e-mail do participante não informado."
