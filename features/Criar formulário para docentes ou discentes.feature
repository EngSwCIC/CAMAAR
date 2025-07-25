Funcionalidade: Criar formulário para docentes ou discentes
  Como administrador
  Quero criar e configurar um formulário com base em um template
  Para enviá-lo especificamente para docentes ou discentes conforme o tipo da avaliação

  @feliz
  Cenário: Criar formulário direcionado a docentes
    Dado que estou logado como administrador
    E tenho um template de Avaliação de docentes pronto
    Quando seleciono "Público-alvo: Docentes"
    E defino as datas de abertura e encerramento
    E associo o formulário a turma ou departamento correto
    Então o formulário é criado com sucesso
    E aparece apenas para os docentes vinculados na área de formulários recebidos

  @feliz
  Cenário: Criar formulário direcionado a discentes
    Dado que estou criando um formulário de avaliação da disciplina
    Quando seleciono "Público-alvo: no Público-alvo: Discentes"
    E vinculoa turma "Engenharia 2025/1"
    Então o sistema envia o formulário apenas para os alunos dessa turma

  @triste
  Cenário: Tentar criar formulário sem selecionar o público-alvo
    Dado que estou na tela de criação formulário
    Quando tento prosseguir sem escolher se o formulário é para docentes ou discentes
    Então vejoa mensagem "Selecione um público-alvo para continuar"
    E o formulário não é criado até que essa informaçāo seja preenchida


