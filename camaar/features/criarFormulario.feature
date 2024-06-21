# language: pt
Funcionalidade: Criar formulário de avaliação

  Eu como administrador
  Quero criar um formulário usando um template escolhido
  A fim de avaliar o desempenho de uma/umas turma(s) no semestre atual


  # FELIZ
  Cenário: Criar formulário de avaliação com sucesso
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando seleciono um template existente
    E especifico as turmas e o semestre atual
    E salvo o novo formulário
    Então o formulário de avaliação é criado com sucesso
    E recebo uma mensagem de confirmação de que o formulário foi criado

  # TRISTE
  Cenário: Falha ao criar formulário devido a falta de seleção de template
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de criação de formulários
    Quando tento salvar o novo formulário sem selecionar um template
    Então recebo uma mensagem de erro indicando que um template deve ser selecionado
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



