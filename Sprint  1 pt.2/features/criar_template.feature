# language: pt
Funcionalidade: Criar modelo de formulário
  Como Administrador
  Quero criar um modelo de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  Contexto:
    Dado que o administrador está autenticado no sistema
    E acessa o módulo de "Gerenciamento"
    E navega para a interface de criação de "Templates"

  Cenário: Criação de um template contendo questões estruturadas (Caminho Feliz)
    Quando o administrador preenche o campo "Título" com "Avaliação de Turma"
    E adiciona uma questão com o enunciado "Avalie a didática" e o tipo "Escala"
    E aciona a opção "Salvar Template"
    Então o sistema deve registrar o modelo no banco de dados
    E exibir a mensagem "Template criado com sucesso"

  Cenário: Falha ao tentar criar template sem associação de questões (Caminho Triste)
    Quando o administrador preenche o campo "Título" com "Avaliação Incompleta"
    E submete o formulário sem adicionar nenhuma questão ao escopo
    Então o sistema deve rejeitar a persistência dos dados
    E exibir a mensagem de validação "O modelo deve conter pelo menos uma questão associada"