# language: pt

#Issue-9

Funcionalidade: Atualizar base de dados com os dados do SIGAA
  Como administrador acadêmico
  Quero atualizar os dados já cadastrados
  A fim de manter a base sincronizada com o SIGAA

  Cenário: Caminho feliz
    Dado que existem novos dados disponíveis no arquivo JSON
    E a base local possui registros antigos
    Quando o administrador solicitar a atualização
    Então os registros devem ser sincronizados
    E a base local deve refletir os novos dados

  Cenário: Caminho triste
    Dado que ocorreu falha na leitura do JSON
    Quando o administrador solicitar a atualização
    Então o sistema deve informar falha na sincronização
    E a base local deve permanecer inalterada
