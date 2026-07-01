# language: pt
Funcionalidade: Criar template de formulário
  Como Administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  Contexto:
    Dado que existe um usuário administrador cadastrado no sistema

  @happy
  Cenário: Administrador cria um template de formulário com sucesso
    Dado que estou autenticado como administrador
    Quando eu acesso a página de criação de template
    E preencho o título do template com "Avaliação de Disciplina"
    E preencho a descrição do template com "Template para avaliação semestral de disciplinas"
    E adiciono uma questão de texto com enunciado "Descreva os pontos positivos da disciplina"
    E adiciono uma questão de múltipla escolha com enunciado "Como você avalia a didática do professor?"
    E adiciono as opções "Ruim", "Regular", "Boa" e "Excelente" para a questão de múltipla escolha
    E confirmo a criação do template
    Então devo ver uma mensagem informando que o template foi criado com sucesso
    E devo ver o template "Avaliação de Disciplina" na lista de templates

  @sad
  Cenário: Administrador tenta criar template sem título
    Dado que estou autenticado como administrador
    Quando eu acesso a página de criação de template
    E deixo o título do template em branco
    E preencho a descrição do template com "Template sem título"
    E adiciono uma questão de texto com enunciado "Descreva os pontos positivos da disciplina"
    E confirmo a criação do template
    Então devo ver uma mensagem informando que o título do template é obrigatório
    E o template não deve ser criado

  @sad
  Cenário: Administrador tenta criar template sem questões
    Dado que estou autenticado como administrador
    Quando eu acesso a página de criação de template
    E preencho o título do template com "Avaliação sem questões"
    E preencho a descrição do template com "Template inválido sem questões"
    E confirmo a criação do template
    Então devo ver uma mensagem informando que o template deve possuir pelo menos uma questão
    E o template não deve ser criado

  @sad
  Cenário: Usuário não administrador tenta criar template
    Dado que existe um usuário não administrador cadastrado no sistema
    E que estou autenticado como usuário não administrador
    Quando eu tento acessar a página de criação de template
    Então devo ver uma mensagem informando que não tenho permissão para criar templates
    E não devo ver o formulário de criação de template
