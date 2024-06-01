# language: pt
Funcionalidade: Criação de formulário para docentes ou discentes

  Eu como administrador
  Quero escolher criar um formulário para os docentes e/ou os dicentes de uma turma
  A fim de avaliar o desempenho de uma matéria

  # FELIZ
  Cenário: Criar formulário para discentes com sucesso
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando escolho criar um formulário para discentes
    E seleciono um template existente para discentes
    E especifico a turma e a matéria a serem avaliadas
    E salvo o novo formulário
    Então o formulário de avaliação para discentes é criado com sucesso
    E recebo uma mensagem de confirmação de que o formulário foi criado

  # FELIZ
  Cenário: Criar formulário para docentes com sucesso
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando escolho criar um formulário para docentes
    E seleciono um template existente para docentes
    E especifico a turma e a matéria a serem avaliadas
    E salvo o novo formulário
    Então o formulário de avaliação para docentes é criado com sucesso
    E recebo uma mensagem de confirmação de que o formulário foi criado

  # FELIZ
  Cenário: Criar formulário para docentes e discentes com sucesso
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando escolho criar um formulário para docentes e discentes
    E seleciono um template existente para docentes e discentes
    E especifico a turma e a matéria a serem avaliadas
    E salvo o novo formulário
    Então os formulários de avaliação para docentes e discentes são criados com sucesso
    E recebo uma mensagem de confirmação de que os formulários foram criados

  # TRISTE
  Cenário: Falha ao criar formulário devido a falta de seleção de tipo de destinatário
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando tento salvar o novo formulário sem escolher se é para docentes e/ou discentes
    Então recebo uma mensagem de erro indicando que o tipo de destinatário deve ser selecionado
    E o formulário não é criado

  # TRISTE
  Cenário: Falha ao criar formulário devido a campos obrigatórios não preenchidos
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando escolho criar um formulário para docentes e/ou discentes
    E não especifico a turma ou a matéria
    E tento salvar o novo formulário
    Então recebo uma mensagem de erro indicando que todos os campos obrigatórios devem ser preenchidos
    E o formulário não é criado

  # TRISTE
  Cenário: Falha ao criar formulário devido a erro técnico
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando escolho criar um formulário para docentes e/ou discentes
    E especifico a turma e a matéria a serem avaliadas
    E tento salvar o novo formulário
    Então ocorre um erro técnico durante o processo de criação
    E recebo uma mensagem de erro informando que houve um problema ao criar o formulário
    E o formulário não é criado

    # TRISTE
  Cenário: Falha ao criar formulário devido a campos obrigatórios não preenchidos
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando seleciono um template existente
    E não especifico todas as turmas ou o semestre
    E tento salvar o novo formulário
    Então recebo uma mensagem de erro indicando que todos os campos obrigatórios devem ser preenchidos
    E o formulário não é criado

    # TRISTE
  Cenário: Falha ao criar formulário devido a falta de seleção de template
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando tento salvar o novo formulário sem selecionar um template
    Então recebo uma mensagem de erro indicando que um template deve ser selecionado
    E o formulário não é criado

