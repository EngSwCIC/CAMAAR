# language: pt
Funcionalidade: Controle departamental de administradores
  Como Administrador
  Quero gerenciar somente as turmas do departamento ao qual pertenço
  A fim de avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que existe um departamento chamado "Departamento de Ciência da Computação"
    E que existe um departamento chamado "Departamento de Matemática"
    E que existe um administrador pertencente ao departamento "Departamento de Ciência da Computação"
    E que estou autenticado como esse administrador

  @happy
  Cenário: Administrador visualiza turma pertencente ao seu departamento
    Dado que existe uma matéria chamada "Introdução à Ciência da Computação" pertencente ao departamento "Departamento de Ciência da Computação"
    E que existe uma turma "A" da matéria "Introdução à Ciência da Computação" no semestre atual
    Quando eu acesso a página de gerenciamento de turmas
    Então devo ver a turma "A" da matéria "Introdução à Ciência da Computação"

  @happy
  Cenário: Administrador cria formulário para turma pertencente ao seu departamento
    Dado que existe uma matéria chamada "Introdução à Ciência da Computação" pertencente ao departamento "Departamento de Ciência da Computação"
    E que existe uma turma "A" da matéria "Introdução à Ciência da Computação" no semestre atual
    E que existe um template chamado "Avaliação de Disciplina"
    Quando eu acesso a página de criação de formulário
    E seleciono a turma "A" da matéria "Introdução à Ciência da Computação"
    E seleciono o template "Avaliação de Disciplina"
    E seleciono o público-alvo "discentes"
    E confirmo a criação do formulário
    Então devo ver uma mensagem informando que o formulário foi criado com sucesso
    E o formulário deve estar associado à turma "A" da matéria "Introdução à Ciência da Computação"

  @happy
  Cenário: Administrador visualiza formulário de turma pertencente ao seu departamento
    Dado que existe uma matéria chamada "Introdução à Ciência da Computação" pertencente ao departamento "Departamento de Ciência da Computação"
    E que existe uma turma "A" da matéria "Introdução à Ciência da Computação" no semestre atual
    E que existe um formulário chamado "Avaliação de ICC" associado à turma "A" da matéria "Introdução à Ciência da Computação"
    Quando eu acesso a página de formulários criados
    Então devo ver o formulário "Avaliação de ICC"

  @sad
  Cenário: Administrador não visualiza turma pertencente a outro departamento
    Dado que existe uma matéria chamada "Cálculo 1" pertencente ao departamento "Departamento de Matemática"
    E que existe uma turma "B" da matéria "Cálculo 1" no semestre atual
    Quando eu acesso a página de gerenciamento de turmas
    Então não devo ver a turma "B" da matéria "Cálculo 1"

  @sad
  Cenário: Administrador não consegue criar formulário para turma de outro departamento
    Dado que existe uma matéria chamada "Cálculo 1" pertencente ao departamento "Departamento de Matemática"
    E que existe uma turma "B" da matéria "Cálculo 1" no semestre atual
    E que existe um template chamado "Avaliação de Disciplina"
    Quando eu acesso a página de criação de formulário
    E seleciono a turma "B" da matéria "Cálculo 1"
    E seleciono o template "Avaliação de Disciplina"
    E seleciono o público-alvo "discentes"
    E pressiono o botão "Criar Formulário"
    Então devo ver uma mensagem informando que não tenho permissão para gerenciar essa turma
    E o formulário não deve ser criado

  @sad
  Cenário: Administrador não consegue acessar formulário de turma de outro departamento
    Dado que existe uma matéria chamada "Cálculo 1" pertencente ao departamento "Departamento de Matemática"
    E que existe uma turma "B" da matéria "Cálculo 1" no semestre atual
    E que existe um formulário chamado "Avaliação de Cálculo 1" associado à turma "B" da matéria "Cálculo 1"
    Quando eu tento acessar o formulário "Avaliação de Cálculo 1"
    Então devo ver uma mensagem informando que não tenho permissão para acessar esse formulário

  @sad
  Cenário: Administrador não consegue exportar resultados de formulário de outro departamento
    Dado que existe uma matéria chamada "Cálculo 1" pertencente ao departamento "Departamento de Matemática"
    E que existe uma turma "B" da matéria "Cálculo 1" no semestre atual
    E que existe um formulário chamado "Avaliação de Cálculo 1" associado à turma "B" da matéria "Cálculo 1"
    Quando eu tento exportar os resultados do formulário "Avaliação de Cálculo 1"
    Então devo ver uma mensagem informando que não tenho permissão para exportar os resultados desse formulário
    E nenhum arquivo CSV deve ser baixado
