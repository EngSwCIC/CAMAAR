# language: pt

Funcionalidade: Importação de dados extraídos do SIGAA

  Como Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA
  Para alimentar a base de dados do sistema

  Cenário: importação de nova turma
    Dado estou autenticado como administrador
    E estou na página "Gerenciamento"
    Quando clicar em "Importar dados"
    E submeter um arquivo JSON contendo informações de uma disciplina, turma e participantes
    Então o sistema deve verificar que essa turma ainda não existe
    E inserir os novos usuários, disciplinas e turmas no banco de dados

  Cenário: Importação de turma repetida
    Dado que estou autenticado como administrador
    E estou na página "Gerenciamento"
    Quando clicar em "Importar dados"
    E submeter um arquivo repetido de importação
    Então o sistema deve abortar a importação
    E mostrar uma mensagem informando dados já cadastrados
