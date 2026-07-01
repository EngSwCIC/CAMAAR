Feature: Atualizar base de dados com informações do SIGAA
  Como um Administrador
  Quero atualizar a base de dados já existente com os dados atuais do SIGAA
  A fim de corrigir a base de dados do sistema

  Background:
    Dado que estou logado no sistema como Administrador
    E estou na página "Atualizar Dados do SIGAA"

  Cenário: Atualizar dados com sucesso (caminho feliz)
    Dado que existem dados desatualizados na base de dados
    Quando eu solicitar a atualização dos dados do SIGAA
    Então o sistema deve atualizar as turmas existentes
    E o sistema deve atualizar as matérias existentes
    E o sistema deve atualizar os participantes existentes
    E eu devo ver "Dados atualizados com sucesso"

  Cenário: Tentar atualizar sem alterações disponíveis (caminho triste)
    Dado que a base de dados já está sincronizada com o SIGAA
    Quando eu solicitar a atualização dos dados do SIGAA
    Então o sistema não deve alterar os registros existentes
    E eu devo ver "Não há novos dados para atualização"
