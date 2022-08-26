#language: pt
Funcionalidade: Visualizar avaliações de todas as turmas do semestre atual
  Eu como administrador
  Quero visualizar as avaliações de todas a turmas de uma maneira rápida e simples, podendo aplicar filtro por
  diciplina, professor e/ou nota
  A fim de avaliar o desempenho das turmas do CIC no semestre atual

  Contexto:
    Dado que eu esteja logado como administrador no CAMAAR
    E eu estou na página de avaliações das turmas
    E exista uma caixa de seleção "Disciplinas" de disciplinas cadastrada no CAMAAR
    E exista uma caixa de seleção de "Professores" professores cadastrados no CAMAAR
    E exista uma caixa de seleção de "Notas" com as notas inteiras possiveis
    E exista uma caixa de selação "Op" com as opções "maior que" e "menor que", sendo a opção "maior que" já selecionada
    E exista um botão "Filtar"

  # Sad path

  Cenario: O administrador quer filtrar as turmas por disciplinas,
  mas não há nenhuma pesquisa registrada para o semestre desta disciplina
    Dado que uma disciplina foi selecionada na caixa de seleção "Disciplinas"
    Quando cliar no botão "Filtar"
    Entao deveria ver uma mensagem na tela dizendo "Nenhuma pesquisa registrada para esta disciplina"

  Cenario: O administrador quer filtrar as turmas por professor,
  mas não há nenhuma pesquisa registrada para o semestre deste professor
    Dado que um professor foi selecionado na caixa de seleção "Professores"
    Quando cliar botão "Filtar"
    Entao deveria ver uma mensagem na tela dizendo "Nenhuma pesquisa registrada para este professor"

  Cenario: O administrador quer filtrar as turmas por notas maiores que um nota,
  mas não há nenhuma turma com nota igual ou superior a esta nota
    Dado que uma nota foi selecionado na caixa de seleção "Notas"
    E a caixa de seleção "Op" esta como "maior que"
    Quando cliar no botão "Filtar"
    Entao deveria ver uma mensagem na tela dizendo "Nenhuma  turma com nota igual ou superior a esta nota"

  Cenario: O administrador quer filtrar as turmas por notas menores que uma nota,
  mas não há nenhuma turma com nota superior a esta nota
    Dado que uma nota foi selecionado na caixa de seleção "Notas"
    E a caixa de seleção "Op" esta como "menor que"
    Quando cliar no botão "Filtar"
    Entao deveria ver uma mensagem na tela dizendo "Nenhuma  turma com nota inferior a esta nota"

  Cenario: O administrador quer filtrar por mais de um atributo,
  mas não há nenhuma turma com os atributos desejados
    Dado que mais de uma caixa de seleção possui um atributo diferente de nulo selecionado (sem contar a caixa de seleção "Op")
    Quando cliar no botão "Filtar"
    Entao deveria ver uma mensagem na tela dizendo "Nenhuma  turma com os atributos desejados"

  # Happy path

  Cenario: O administrador quer filtrar as turmas por disciplinas
    Dado que uma disciplina foi selecionada na caixa de seleção "Disciplinas"
    Quando cliar no botão "Filtar"
    Entao apenas as turmas da disciplina selecionada devem aparecer

  Cenario: O administrador quer filtrar as turmas por professor
    Dado que um professor foi selecionado na caixa de seleção "Professores"
    Quando cliar botão "Filtar"
    Entao apenas as turmas do professor selecionado devem aparecer

  Cenario: O administrador quer filtrar as turmas por notas igual ou maiores que um nota
    Dado que uma nota foi selecionado na caixa de seleção "Notas"
    E a caixa de seleção "Op" esta como "maior que"
    Quando cliar no botão "Filtar"
    Entao apenas as turmas com nota igual ou maior que a nota selecionada devem aparecer

  Cenario: O administrador quer filtrar as turmas por notas menores que um nota
    Dado que uma nota foi selecionado na caixa de seleção "Notas"
    E a caixa de seleção "Op" esta como "menor que"
    Quando cliar no botão "Filtar"
    Entao apenas as turmas com nota menor que a nota selecionada devem aparecer


