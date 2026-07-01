# language: pt
Funcionalidade: Enviar convites de cadastro SIGAA
  Como Administrador
  Quero enviar convites para usuários pendentes do meu departamento
  A fim de permitir que docentes e discentes importados definam suas senhas

  Contexto:
    Dado que existe um usuário administrador cadastrado no sistema
    E que estou autenticado como administrador

  @happy
  Cenário: Administrador envia convites para usuários pendentes do departamento
    Dado que existe um discente pendente de cadastro no meu departamento com matrícula "240001"
    E que o envio de convites de cadastro será bem-sucedido
    Quando envio as solicitações de cadastro pelo gerenciamento
    Então deve existir um token de cadastro para a matrícula "240001"
    E eu devo ver o resultado de envio de convites com 1 sucesso

  @sad
  Cenário: Administrador sem usuários pendentes vê aviso
    Quando envio as solicitações de cadastro pelo gerenciamento
    Então eu devo ver o aviso de que não há usuários pendentes no departamento

  @sad
  Cenário: Falha de envio mantém usuário sem token
    Dado que existe um docente pendente de cadastro no meu departamento com matrícula "DOC-FALHA"
    E que o envio de convites de cadastro falhará
    Quando envio as solicitações de cadastro pelo gerenciamento
    Então não deve existir token de cadastro para a matrícula "DOC-FALHA"
    E eu devo ver erro de envio de convites
