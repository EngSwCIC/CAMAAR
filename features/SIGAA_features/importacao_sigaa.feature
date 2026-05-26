# language: pt

Funcionalidade: Importação de dados inéditos do SIGAA
  Como Administrador
  Para que eu possa alimentar a base de dados do sistema
  Eu quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)

  Contexto:
    Dado que estou autenticado no sistema com o perfil de administrador
    E acesso a área de integração com o SIGAA

  @cenario_feliz
  Cenário: Importação bem-sucedida de novos registros
    Quando eu solicito a importação de dados do semestre atual
    Então o sistema deve extrair os dados do SIGAA
    E criar as novas instâncias de disciplinas e turmas que ainda não existem
    E exibir a mensagem "Importação concluída com sucesso"

  @cenario_triste
  Cenário: Importação de dados com campos obrigatórios ausentes
    Quando eu solicito a importação de dados do SIGAA
    E o pacote de dados recebido não contém o "código" de algumas disciplinas
    Então o sistema deve interromper a criação desses registros específicos
    E exibir um relatório de erro informando "Falha na importação: Códigos de disciplina ausentes"

  @cenario_triste
  Cenário: Falha de conexão com a API do SIGAA
    Quando eu inicio o processo de importação
    E o servidor do SIGAA está temporariamente indisponível
    Então o sistema deve cancelar a operação
    E exibir a mensagem "Erro de conexão com o SIGAA. Tente novamente mais tarde."

  @cenario_triste
  Cenário: Importação de conjunto de dados vazio
    Quando eu solicito a importação de dados para um semestre futuro que ainda não foi cadastrado no SIGAA
    Então o sistema não deve alterar a base de dados atual
    E deve exibir o alerta "Nenhum dado novo encontrado para importação neste período."