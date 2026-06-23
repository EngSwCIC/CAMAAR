# language: pt
Funcionalidade: Importação de Dados do SIGAA

  Como um Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA
  A fim de alimentar a base de dados do sistema

  Cenário: Sincronização de dados realizada com sucesso (inserção e atualização)
    Dado que eu acesse a tela de "Importação de Dados do SIGAA"
    Quando eu selecionar o período letivo desejado
    E solicitar a sincronização de "Turmas, Matérias e Participantes"
    Então o sistema deve consultar o SIGAA (arquivos no repositório original)
    E deve inserir os novos registros identificados
    E deve atualizar os dados dos registros que sofreram alterações no SIGAA
    E exibir a mensagem: "Sincronização concluída. X novos registros adicionados e Y registros atualizados."

  Cenário: Tentativa de importação quando todos os dados já estão atualizados
    Dado que todos os dados do SIGAA para o período atual já tenham sido importados previamente
    E eu acesse a tela de "Importação de Dados do SIGAA"
    Quando eu solicitar a sincronização dos dados
    Então o sistema deve verificar a base de dados
    E constatar que não há novos registros para inserir
    E deve finalizar o processo exibindo a mensagem: "A base de dados já está atualizada com o SIGAA para este período."