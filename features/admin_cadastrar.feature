#language: pt
Funcionalidade: Cadastrar usuários do sistema
  Eu como Administrador
  Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
  A fim de que eles acessem o sistema CAMAAR

  Contexto:
    Dado que eu estou logado como admin
    E que eu estou na página de gerenciamento do CAMAAR
    Quando eu clicar no botão "Importar dados"

  Cenário: Upload de dados dos usuários bem-sucedido (HAPPY)
    E eu selecionar o arquivo "valido.json" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E um email deve ter sido enviado para "myemail@email"
    E eu devo ver "Alunos notificados com sucesso"

  Cenário: Tentativa de upload de arquivo de tipo inválido (SAD)
    E eu selecionar o arquivo "invalido.txt" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Arquivo com extensão inválida"

  Cenário: Tentativa de upload de arquivo com informações inválidas (SAD)
    E eu selecionar o arquivo "invalido.json" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Arquivo de dados inválido"