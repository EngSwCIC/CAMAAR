# language: pt
Funcionalidade: (#109) Visualização de formulários para responder
  Como um Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de poder escolher qual irei responder

  Cenário: Listar formulários em aberto disponíveis para o aluno (Caminho Feliz)
    Dado que eu sou um "usuarios" com "perfil" "discente" e possuo uma "matriculas" na "turmas" "CIC0105"
    E existe um "formularios" direcionado à minha turma onde o "status" é "aberto" e o "publico_alvo" é "discente"
    E a data atual está entre a "data_inicio" e a "data_limite"
    E eu não possuo nenhum registro correspondente na tabela "respostas" para este formulário
    Quando eu entro na rota de listagem de avaliações pendentes
    Então a view deve exibir as informações do formulário e o "codigo_turma" da turma correspondente

  Cenário: Não exibir formulários fora do período de vigência (Caminho Triste - Prazo Expirado)
    Dado que o "formularios" da minha turma possui uma "data_limite" definida no passado
    Quando eu entro na rota de listagem de avaliações pendentes
    Então a página não deve listar este formulário como disponível para preenchimento

  Cenário: Usuário sem matrícula ativa tenta listar questionários da turma (Caminho Triste - Sem Vínculo)
    Dado que existe um "formularios" com "status" "aberto" para a turma "TA"
    Mas eu não possuo um registro correspondente na tabela "matriculas" vinculando meu "usuario_id" ao "turma_id" daquela turma
    Quando eu forço o acesso à listagem de avaliações
    Então a view deve exibir a mensagem "Você não possui formulários pendentes para responder no momento"