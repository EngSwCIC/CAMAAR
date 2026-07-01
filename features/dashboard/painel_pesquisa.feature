# language: pt
Funcionalidade: Painel inicial e pesquisa
  Como Usuário autenticado
  Quero navegar pelo painel e pesquisar itens
  A fim de encontrar avaliações e recursos disponíveis ao meu perfil

  @happy
  Cenário: Participante visualiza resumo de avaliações pendentes no painel inicial
    Dado que existe um usuário participante cadastrado no sistema
    E que estou autenticado como participante
    E que estou matriculado na turma "Cálculo 1"
    E que existe um formulário pendente para a turma "Cálculo 1"
    Quando acesso a tela inicial
    Então devo ver a saudação do usuário autenticado
    E devo ver a avaliação pendente da turma "Cálculo 1" no painel inicial
    E não devo ver a área de administração no painel inicial

  @happy
  Cenário: Administrador visualiza atalhos de administração no painel inicial
    Dado que existe um usuário administrador cadastrado no sistema
    E que estou autenticado como administrador
    Quando acesso a tela inicial
    Então devo ver a área de administração no painel inicial
    E devo ver o link de gerenciamento no menu lateral

  @happy
  Cenário: Participante pesquisa apenas avaliações pendentes
    Dado que existe um usuário participante cadastrado no sistema
    E que estou autenticado como participante
    E que estou matriculado na turma "Cálculo 1"
    E que existe um formulário pendente para a turma "Cálculo 1"
    Quando pesquiso por "Cálculo"
    Então devo ver resultados de avaliações pendentes para "Cálculo 1"
    E não devo ver resultados administrativos na pesquisa

  @happy
  Cenário: Administrador pesquisa templates e formulários
    Dado que existe um usuário administrador cadastrado no sistema
    E que estou autenticado como administrador
    E que existe um template chamado "Avaliação de Disciplina" criado por mim
    E que existe um formulário chamado "Formulário de Avaliação de Cálculo 1" criado a partir do template "Avaliação de Disciplina"
    Quando pesquiso por "Avaliação"
    Então devo ver resultados de templates para "Avaliação de Disciplina"
    E devo ver resultados de formulários para a turma "Cálculo 1"

  @happy
  Cenário: Administrador recebe sugestões de pesquisa com escopo correto
    Dado que existe um usuário administrador cadastrado no sistema
    E que estou autenticado como administrador
    E que existe uma matéria chamada "Cálculo 1" pertencente ao departamento "Departamento de Ciência da Computação"
    E que existe uma turma "A" da matéria "Cálculo 1" no semestre atual
    E que existe um template chamado "Avaliação de Disciplina" criado por mim
    Quando consulto as sugestões de pesquisa por "Cálculo 1 A"
    Então devo receber uma sugestão de turma "Cálculo 1"
    E a sugestão de turma deve restringir a pesquisa sem templates
    Quando consulto as sugestões de pesquisa por "Avaliação"
    Então devo receber uma sugestão de template "Avaliação de Disciplina"

  @happy
  Cenário: Menu do usuário é preparado para fechar fora da caixa
    Dado que existe um usuário administrador cadastrado no sistema
    E que estou autenticado como administrador
    Quando acesso a tela inicial
    Então o menu do usuário deve estar configurado para fechar ao clicar fora
