# language: pt
Funcionalidade: Criar formulário a partir de template
  Como Administrador
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que estou autenticado como administrador
    E que existe um template cadastrado chamado "Avaliação de Desempenho Docente"
    E que existem as turmas "Métodos de Desenvolvimento de Software - Turma A" e "Interação Humano Computador - Turma B" cadastradas no semestre atual

  @happy
  Cenário: Criar formulário para múltiplas turmas com sucesso
    Dado que estou na página de criação de formulários
    Quando eu seleciono o template "Avaliação de Desempenho Docente"
    E seleciono as turmas "Métodos de Desenvolvimento de Software - Turma A" e "Interação Humano Computador - Turma B"
    E seleciono a opção de público-alvo como "Docentes"
    E clico em "Publicar formulário"
    Então o formulário deve ser gerado com sucesso para ambas as turmas
    E devo ver a mensagem "Formulário criado com sucesso para as turmas selecionadas"

  @happy
  Cenário: Iniciar criação de formulário pela visualização do template
    Dado que estou visualizando o template cadastrado chamado "Avaliação de Desempenho Docente"
    Quando solicito criar um formulário a partir desse template
    Então devo estar na página de criação de formulários com o template "Avaliação de Desempenho Docente" selecionado
    Quando seleciono as turmas "Métodos de Desenvolvimento de Software - Turma A" e "Interação Humano Computador - Turma B"
    E seleciono a opção de público-alvo como "Docentes"
    E clico em "Publicar formulário"
    Então o formulário deve ser gerado com sucesso para ambas as turmas
    E devo ver a mensagem "Formulário criado com sucesso para as turmas selecionadas"

  @happy
  Cenário: Exibir seleção de template, público-alvo e filtros de turmas na mesma tela
    Dado que existe o professor "Professora Ada" vinculado à turma "Métodos de Desenvolvimento de Software - Turma A"
    E que existe o professor "Professor Sem Turma" no meu departamento
    Quando estou na página de criação de formulários filtrando pela matéria "Métodos de Desenvolvimento de Software"
    Então devo ver o controle segmentado de público-alvo com as opções "Docentes" e "Discentes"
    E devo ver todas as turmas dentro da mesma caixa de seleção
    E devo ver o filtro de turmas com seções recolhidas para matéria e professor
    E devo ver buscas específicas para matéria e professor no filtro de turmas
    E devo ver "Professora Ada" e "Professor Sem Turma" como opções de filtro por professor

  @sad
  Cenário: Tentar criar formulário sem selecionar nenhuma turma
    Dado que estou na página de criação de formulários
    Quando eu seleciono o template "Avaliação de Desempenho Docente"
    E não seleciono nenhuma turma
    E seleciono a opção de público-alvo como "Docentes"
    E clico em "Publicar formulário"
    Então eu devo ver uma mensagem de erro dizendo "É necessário selecionar pelo menos uma turma"
    E nenhum formulário deve ser gerado

  @sad
  Cenário: Tentar criar formulário sem selecionar template
    Dado que estou na página de criação de formulários
    Quando seleciono as turmas "Métodos de Desenvolvimento de Software - Turma A" e "Interação Humano Computador - Turma B"
    E seleciono a opção de público-alvo como "Docentes"
    E clico em "Publicar formulário"
    Então eu devo ver uma mensagem de erro dizendo "Template ou turma não encontrados"
    E nenhum formulário deve ser gerado

  @sad
  Cenário: Tentar criar formulário a partir de template sem questões
    Dado que existe um template sem questões chamado "Template vazio"
    E que estou na página de criação de formulários
    Quando eu seleciono o template "Template vazio"
    E seleciono as turmas "Métodos de Desenvolvimento de Software - Turma A" e "Interação Humano Computador - Turma B"
    E seleciono a opção de público-alvo como "Docentes"
    E clico em "Publicar formulário"
    Então eu devo ver uma mensagem de erro dizendo "O template deve possuir pelo menos uma questão"
    E nenhum formulário deve ser gerado

  @sad
  Cenário: Tentar publicar formulário duplicado para a mesma turma, template e público-alvo
    Dado que existe um formulário já publicado para a turma "Métodos de Desenvolvimento de Software - Turma A" com público-alvo "Docentes"
    E que estou na página de criação de formulários
    Quando eu seleciono o template "Avaliação de Desempenho Docente"
    E seleciono a turma "Métodos de Desenvolvimento de Software - Turma A"
    E seleciono a opção de público-alvo como "Docentes"
    E clico em "Publicar formulário"
    Então eu devo ver uma mensagem de erro dizendo "Uma ou mais turmas selecionadas já possuem formulário para este template e público-alvo"
    E deve existir apenas um formulário para a turma "Métodos de Desenvolvimento de Software - Turma A"

  @sad
  Cenário: Exibir apenas turmas vigentes do departamento do administrador
    Dado que existe uma turma de outro departamento chamada "Redes de Computadores - Turma A"
    E que existe uma turma passada chamada "Arquitetura de Computadores - Turma A"
    Quando estou na página de criação de formulários
    Então devo ver a turma "Métodos de Desenvolvimento de Software - Turma A" disponível para seleção
    E não devo ver a turma "Redes de Computadores - Turma A" disponível para seleção
    E não devo ver a turma "Arquitetura de Computadores - Turma A" disponível para seleção

  @sad
  Cenário: Tentar publicar turma de outro departamento pela requisição
    Dado que existe uma turma de outro departamento chamada "Redes de Computadores - Turma A"
    Quando tento publicar formulário para a turma "Redes de Computadores - Turma A" pela requisição
    Então eu devo ver uma mensagem de erro dizendo "Uma ou mais turmas selecionadas são inválidas"
    E nenhum formulário deve ser gerado
