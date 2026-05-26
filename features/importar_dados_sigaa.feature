Feature: Importação de dados do SIGAA
  Como Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
  A fim de alimentar a base de dados do sistema

  Background:
    Given que o administrador está autenticado no sistema
    And que o administrador possui permissão para importar dados do SIGAA via arquivos JSON

  Scenario: Sincronização bem-sucedida de turmas e participantes (Happy Path)
    Given que os arquivos selecionados são "classes.json" e "class_members.json" e possuem dados válidos
    When o administrador inicia o carregamento dos arquivos no sistema
    And confirma a operação de importação
    Then o sistema deve salvar a matéria inédita "BANCOS DE DADOS", de código "CIC0097" (turma "TA") no banco de dados
    And deve registrar e vincular a docente "MARISTELA TERTO DE HOLANDA" à respectiva turma
    And deve registrar os discentes da lista, como "Ana Clara Jordao Perna" e "Andre Carvalho de Roure", vinculando-os à turma "CIC0097"
    And deve exibir a mensagem "Importação de dados concluída com sucesso"

  Scenario: Falha ao tentar importar arquivos com estruturação incompatível (Sad Path)
    Given que o administrador selecionou um arquivo corrompido ou que não segue a estrutura JSON esperada para turmas e participantes
    When o administrador tenta realizar a importação do arquivo
    Then o sistema deve bloquear o processamento do arquivo imediatamente
    And não deve realizar nenhuma inclusão de matérias, docentes ou discentes no banco de dados
    And deve exibir uma mensagem alertando que o arquivo enviado é inválido ou incompatível