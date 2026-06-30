# language: pt

Funcionalidade: Gerenciamento por Departamento
  Como coordenador de departamento
  Quero gerenciar os formulários e turmas vinculados ao meu departamento
  Para que eu possa organizar e acompanhar as avaliações da minha área

  Cenário: Coordenador visualiza turmas do seu departamento
    Dado que estou logado como coordenador de departamento
    Quando acesso a seção de gerenciamento do departamento
    Então vejo apenas as turmas vinculadas ao meu departamento
    E posso visualizar os formulários associados a cada turma

  Cenário: Coordenador associa formulário a uma turma do departamento
    Dado que estou logado como coordenador de departamento
    E existe uma turma vinculada ao meu departamento
    E existe um formulário criado para o departamento
    Quando seleciono a turma e associo o formulário
    E clico em "Salvar"
    Então o formulário fica disponível para os estudantes da turma
    E vejo uma mensagem de confirmação da associação

  Cenário: Coordenador tenta gerenciar turma de outro departamento
    Dado que estou logado como coordenador de departamento
    E existe uma turma vinculada a outro departamento
    Quando tento acessar o gerenciamento dessa turma
    Então o sistema nega o acesso
    E vejo uma mensagem informando que a turma não pertence ao meu departamento

  Cenário: Coordenador remove associação de formulário de uma turma
    Dado que estou logado como coordenador de departamento
    E existe uma turma do meu departamento com um formulário associado
    Quando seleciono a turma e removo a associação do formulário
    E clico em "Confirmar remoção"
    Então o formulário deixa de estar disponível para os estudantes da turma
    E vejo uma mensagem de confirmação da remoção
