# language: pt
# features/atualizar_dados_sigaa.feature

Funcionalidade: Atualizar base de dados com os dados do SIGAA
  Eu como Administrador
  Quero atualizar a base de dados já existente com os dados atuais do sigaa
  A fim de corrigir a base de dados do sistema.

  Contexto:
    Dado que eu estou logado como Administrador
    E estou na página "Gerenciamento"

  @happy_path
  Cenário: Sincronizar participante que mudou de e-mail
    Dado que o usuário "Fulano de Tal" (150084006) já existe no sistema com o e-mail "fulano.antigo@email.com"
    E a fonte de dados externa indica que o e-mail de "150084006" agora é "fulano.novo@gmail.com"
    Quando eu clico no botão "Importar dados"
    Então o e-mail do usuário "150084006" deve ser atualizado para "fulano.novo@gmail.com"
    E nenhum usuário duplicado deve ser criado
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"

  @happy_path
  Cenário: Sincronizar matrícula de participante em nova turma
    Dado que o usuário "Fulano de Tal" (150084006) já existe no sistema
    E a turma "BANCOS DE DADOS" (CIC0097) também já existe no sistema
    E o usuário "Fulano de Tal" ainda não está matriculado na turma "BANCOS DE DADOS"
    E a fonte de dados externa indica que "150084006" está matriculado em "CIC0097"
    Quando eu clico no botão "Importar dados"
    Então o usuário "Fulano de Tal" deve ser matriculado na turma "BANCOS DE DADOS"
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"

  @happy_path
  Cenário: Sincronizar participante que mudou de nome
    Dado que o usuário "Fulano de Tal" (150084006) já existe no sistema com o nome "Fulano de Tal"
    E a fonte de dados externa indica que o nome de "150084006" agora é "Fulano da Silva"
    Quando eu clico no botão "Importar dados"
    Então o nome do usuário "150084006" deve ser atualizado para "Fulano da Silva"
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"

  @happy_path
  Cenário: Sincronizar turma que mudou de nome
    Dado que a turma "BANCOS DE DADOS" (CIC0097) já existe no sistema com o nome "BANCOS DE DADOS"
    E a fonte de dados externa indica que o nome da turma "CIC0097" agora é "BANCOS DE DADOS AVANÇADO"
    Quando eu clico no botão "Importar dados"
    Então o nome da turma "CIC0097" deve ser atualizado para "BANCOS DE DADOS AVANÇADO"
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"

  @happy_path
  Cenário: Sincronizar participante que foi removido do SIGAA
    Dado que o usuário "Fulano de Tal" (150084006) já existe no sistema
    E a fonte de dados externa indica que "150084006" não está mais presente
    Quando eu clico no botão "Importar dados"
    Então o usuário "150084006" deve ser desativado no sistema
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"

  @happy_path
  Cenário: Sincronizar turma que foi removida do SIGAA
    Dado que a turma "BANCOS DE DADOS" (CIC0097) já existe no sistema
    E a fonte de dados externa indica que "CIC0097" não está mais presente
    Quando eu clico no botão "Importar dados"
    Então a turma "CIC0097" deve ser desativada no sistema
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"
  
  @happy_path
  Cenário: Sincronizar participante com múltiplas mudanças
    Dado que o usuário "Fulano de Tal" (150084006) já existe no sistema com o e-mail "fulano.antigo@email.com" e o nome "Fulano de Tal"
    E a fonte de dados externa indica que o e-mail de "150084006" agora é "fulano.novo@email.com" e o nome agora é "Fulano da Silva"
    Quando eu clico no botão "Importar dados"
    Então o e-mail do usuário "150084006" deve ser atualizado para "fulano.novo@email.com"
    E o nome do usuário "150084006" deve ser atualizado para "Fulano da Silva"
    E eu devo ver a mensagem de sucesso "Dados atualizados com sucesso!"

  @sad_path
  Cenário: Falha ao buscar os dados externos
    Dado que o sigaa está indisponível
    Quando eu clico no botão "Importar dados"
    Então eu devo ver a mensagem de erro "Não foi possível buscar os dados. Tente novamente mais tarde."
    E nenhuma nova turma deve ser cadastrada no sistema
    E nenhum novo usuário deve ser cadastrado no sistema