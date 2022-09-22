#language: pt
Funcionalidade: Cadastrar Usuarios no SIGAA

  Contexto:
    Dado que eu estou na pagina de registro

  Cenario: Testando a Pagina de Registro
    Entao eu deveria ver o campo "email"
    E eu deveria ver o campo "senha"
    E eu deveria ver o botão "register"
    E eu deveria ver o botão "voltar"

  Cenário:  Registrar com campos invalidos: senha (sad path)
    E eu escrever "meuemail@mail.com" no campo "email"
    Quando eu clicar em "register"
    Então eu devo ver uma notificação no formulario de Senha Obrigatoria e o conteudo no campo da "senha" tem que ser vazio

  Cenário:  Registrar com campos invalidos: email (sad path)
    E eu escrever "batatinha123" no campo "senha"
    Quando eu clicar em "register"
    Então eu devo ver uma notificação no formulario de E-Mail Obrigatório e o conteudo no campo do "email" tem que ser vazio

  Cenario: Testando Registro com campos válidos não estando o email presente no banco de dados "members"(sad path)
    Quando eu escrever "meuemail@mail.com" no campo "email"
    E eu escrever "batatinha123" no campo "senha"
    E eu clicar em "register"
    E se em members nao existe nenhum membro com o email "meuemail@mail.com" escrito no campo email
    Então eu devo ver uma notificação de "Error ao cadastrar usuario"

  Cenario: Testando Registro com campos válidos estando o email presente no banco de dados "users"(sad path)
    Quando eu escrever "meuteste@mail.com" no campo "email"
    E eu escrever "batatinha123" no campo "senha"
    E se em users existe algum user com o email "meuteste@mail.com" escrito no campo email
    E eu clicar em "register"
    Então eu devo ver uma notificação de "Error ao cadastrar usuario"

  Cenario: Testando Registro com campos válidos não estando o email presente no banco de dados "users" e estando presente no banco de dados "member" (happy path)
    Quando eu escrever "andre.acm97@outlook.com" no campo "email"
    E eu escrever "batatinha123" no campo "senha"
    E se em members existe algum member e nenhum user com o email "andre.acm97@outlook.com" escrito no campo email
    E eu clicar em "register"
    Então eu devo ver uma notificação de "Cadastrado com sucesso"
