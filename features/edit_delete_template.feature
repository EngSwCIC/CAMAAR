# language: pt

#Issue-5

Funcionalidade: Edição e deleção de templates
  Como administrador
  Quero editar e deletar templates de formulário existentes
  A fim de manter os templates atualizados e remover os que não são mais necessários

  Cenário: [Feliz] Editar o nome de um template existente com sucesso
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Docente 2024.1" está cadastrado no sistema
    Quando eu abro o editor do template "Avaliação Docente 2024.1"
    E altero o campo "Nome do template" para "Avaliação Docente 2024.2"
    E clico no botão "Confirmar"
    Então o template "Avaliação Docente 2024.2" deve aparecer na listagem de templates
    E o template "Avaliação Docente 2024.1" não deve aparecer na listagem de templates

  Cenário: [Feliz] Editar o enunciado de uma questão existente com sucesso
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Semestral" está cadastrado no sistema
    Quando eu abro o editor do template "Avaliação Semestral"
    E altero o enunciado da questão "Como você avalia o docente?" para "Como você avalia a atuação do docente na disciplina?"
    E clico no botão "Confirmar"
    Então a questão "Como você avalia a atuação do docente na disciplina?" deve aparecer no template "Avaliação Semestral"

  Cenário: [Feliz] Adicionar uma nova questão a um template existente com sucesso
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Semestral" está cadastrado no sistema
    Quando eu abro o editor do template "Avaliação Semestral"
    E adiciono uma questão do tipo "Texto" com o enunciado "Sugestões de melhoria para o semestre"
    E clico no botão "Confirmar"
    Então o template "Avaliação Semestral" deve conter a questão "Sugestões de melhoria para o semestre"

  Cenário: [Feliz] Editar um template não afeta formulários já criados a partir dele
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Docente 2024.1" está cadastrado no sistema
    E que existe um formulário criado a partir do template "Avaliação Docente 2024.1"
    Quando eu abro o editor do template "Avaliação Docente 2024.1"
    E altero o campo "Nome do template" para "Avaliação Docente 2024.2"
    E clico no botão "Confirmar"
    Então o formulário criado anteriormente deve manter as questões originais do template "Avaliação Docente 2024.1"

  Cenário: [Feliz] Deletar um template não afeta formulários já criados a partir dele
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Docente 2024.1" está cadastrado no sistema
    E que existe um formulário criado a partir do template "Avaliação Docente 2024.1"
    Quando eu clico no ícone de deletar do card "Avaliação Docente 2024.1"
    E confirmo a exclusão do template
    Então o formulário criado anteriormente deve continuar disponível e inalterado

  Cenário: [Triste] Tentar salvar a edição com o nome do template vazio
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Docente 2024.1" está cadastrado no sistema
    Quando eu abro o editor do template "Avaliação Docente 2024.1"
    E deixo o campo "Nome do template" em branco
    E clico no botão "Confirmar"
    Então o sistema deve exibir a mensagem de erro "O nome do template é obrigatório"
    E as alterações não devem ser salvas

  Cenário: [Triste] Tentar salvar a edição com enunciado de questão vazio
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Semestral" está cadastrado no sistema
    Quando eu abro o editor do template "Avaliação Semestral"
    E apago o enunciado de uma das questões existentes
    E clico no botão "Confirmar"
    Então o sistema deve exibir a mensagem de erro "O enunciado da questão é obrigatório"
    E as alterações não devem ser salvas

  Cenário: [Triste] Tentar salvar a edição de questão do tipo Radio sem opções de resposta
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Semestral" está cadastrado no sistema
    Quando eu abro o editor do template "Avaliação Semestral"
    E removo todas as opções de resposta de uma questão do tipo "Radio"
    E clico no botão "Confirmar"
    Então o sistema deve exibir a mensagem de erro "Questões do tipo Radio devem ter ao menos uma opção de resposta"
    E as alterações não devem ser salvas

  Cenário: [Feliz] Deletar um template existente com sucesso após confirmação
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Docente 2024.1" está cadastrado no sistema
    Quando eu clico no ícone de deletar do card "Avaliação Docente 2024.1"
    E confirmo a exclusão do template
    Então o template "Avaliação Docente 2024.1" não deve aparecer na listagem de templates

  Cenário: [Alternativo] Cancelar a deleção mantém o template na listagem
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    E eu acesso a página de gerenciamento de templates
    E que o template "Avaliação Docente 2024.1" está cadastrado no sistema
    Quando eu clico no ícone de deletar do card "Avaliação Docente 2024.1"
    E cancelo a exclusão do template
    Então o template "Avaliação Docente 2024.1" deve permanecer na listagem de templates

  Cenário: [Triste] Participante tenta editar um template existente
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    Quando eu acesso a URL de gerenciamento de templates
    Então o sistema deve exibir a mensagem "Você não tem permissão para acessar esta página"
    E eu devo ser redirecionado para a página inicial do meu perfil
