# language: pt

@issue-109
Funcionalidade: Visualização de formulários disponíveis para resposta
  Como participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  Para escolher qual irei responder

  Contexto:
    Dado que existe um usuário participante autenticado
    E o usuário está matriculado na turma "CIC101"
    E existe o formulário "Avaliação da disciplina" não respondido nessa turma
    E existe o formulário "Avaliação do professor" já respondido
    E o usuário está na página de formulários disponíveis

  Cenário: Exibir apenas formulários não respondidos
    Quando o usuário visualiza a lista de formulários disponíveis
    Então o sistema deve exibir o formulário "Avaliação da disciplina"
    E o sistema não deve exibir o formulário "Avaliação do professor"

  Cenário: Usuário sem formulários pendentes
    Dado que o usuário respondeu todos os formulários das turmas em que está cadastrado
    Quando acessa a página de formulários
    Então o sistema deve exibir a mensagem "Nenhum formulário pendente para resposta"

  Cenário: Detalhar um formulário para responder
    Quando o usuário seleciona o formulário "Avaliação da disciplina"
    Então o sistema deve exibir a descrição e as questões do formulário
    E deve permitir que o usuário inicie a resposta

  Cenário: Usuário tenta acessar formulário que não pertence à sua turma
    Quando o usuário tenta acessar o formulário da turma "MAT002"
    Então o sistema deve bloquear o acesso
    E deve exibir a mensagem "Você não está matriculado nesta turma"