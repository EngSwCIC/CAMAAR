# language: pt

Funcionalidade: Nova issue de exemplo
  Como um usuário
  Eu quero criar uma nova issue
  De modo que ela apareça no meu Projects to Github

  Contexto:
    Dado que estou logado no sistema

  # CENÁRIOS FELIZES

  Cenário: Criar issue com sucesso
    Dado que estou na página de criação de issues
    Quando eu preencho o título com "Nova funcionalidade de teste"
    E eu preencho a descrição com "Esta é uma descrição detalhada da issue"
    E eu clico no botão "Criar Issue"
    Então devo ver a mensagem "Issue criada com sucesso"
    E a issue deve aparecer na lista de issues do projeto
    E a issue deve estar visível no Projects do Github

  # CENÁRIOS TRISTES

  Cenário: Tentar criar issue sem título
    Dado que estou na página de criação de issues
    Quando eu deixo o campo título vazio
    E eu preencho a descrição com "Descrição sem título"
    E eu clico no botão "Criar Issue"
    Então devo ver a mensagem de erro "O título é obrigatório"
    E a issue não deve ser criada

  Cenário: Tentar criar issue sem descrição
    Dado que estou na página de criação de issues
    Quando eu preencho o título com "Issue sem descrição"
    E eu deixo a descrição vazia
    E eu clico no botão "Criar Issue"
    Então devo ver a mensagem de erro "A descrição é obrigatória"
    E a issue não deve ser criada
