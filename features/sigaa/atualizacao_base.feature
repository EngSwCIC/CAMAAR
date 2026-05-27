# language: pt

Funcionalidade: Atualizar base de dados com os dados do SIGAA
  Eu como Administrador
  Quero atualizar a base de dados já existente com os dados atuais do SIGAA
  A fim de corrigir a base de dados do sistema.

  Contexto:
    Dado que eu estou logado como Administrador
    E estou na página "Gerenciamento"

  @happy
  Cenário: Sincronizar participante que mudou de e-mail
    Dado que o usuário "usuario" (190084006) já existe no sistema com o e-mail "usuario@email.com"
    E a fonte de dados externa indica que o e-mail de "190084006" agora é "usuarionovo@gmail.com"
    Quando eu clico no botão "Importar dados"
    Então o e-mail do usuário "190084006" deve ser atualizado para "usuarionovo@gmail.com"
    E nenhum usuário duplicado deve ser criado
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"

  @happy
  Cenário: Sincronizar participante que mudou de nome
    Dado que o usuário "nome genérico" (200033522) já existe no sistema com o nome "nome genérico"
    E a fonte de dados externa indica que o nome de "200033522" agora é "nome não genérico"
    Quando eu clico no botão "Importar dados"
    Então o nome do usuário "200033522" deve ser atualizado para "nome não genérico"
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"


  @happy
  Cenário: Sincronizar participante com múltiplas mudanças
    Dado que o usuário "usuario" (190084006) já existe no sistema com o e-mail "usuario@email.com" e o nome "usuario"
    E a fonte de dados externa indica que o e-mail de "190084006" agora é "usuarioemail@gmail.com" e o nome agora é "usuario com email"
    Quando eu clico no botão "Importar dados"
    Então o e-mail do usuário "190084006" deve ser atualizado para "usuarioemail@gmail.com"
    E o nome do usuário "190084006" deve ser atualizado para "usuario com email"
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"

  @sad
  Cenário: Falha ao buscar os dados
    Dado que o SIGAA está indisponível
    Quando eu clico no botão "Importar dados"
    Então eu devo ver a mensagem de erro "Não foi possível buscar os dados. Tente novamente mais tarde."
    E nenhuma turma existente deve ser alterada no sistema
    E nenhum usuário existente deve ser alterado no sistema
