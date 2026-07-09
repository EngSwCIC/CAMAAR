# language: pt

#Issue-15

Funcionalidade: Criar template de formulários
    Como administrador
    Quero criar um novo template de formulário
    A fim de utilizar este template para criar novos formulários

    Cenário: [Feliz] Criar um novo template com questão do tipo Texto e questão do tipo Radio
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        E eu acesso a página de gerenciamento de templates
        Quando seleciono a opção de criar um novo template
        E preencho o campo "Nome do template" com "Avaliação Docente 2024.1"
        E adiciono uma questão do tipo "Texto" com o enunciado "Deixe seu comentário sobre a disciplina"
        E adiciono uma questão do tipo "Radio" com o enunciado "Como você avalia o docente?" e as opções "Ótimo", "Bom" e "Regular"
        E clico no botão "Criar"
        Então o template "Avaliação Docente 2024.1" deve aparecer na listagem de templates
        E deve estar disponível para uso em novos formulários

    Cenário: [Triste] Tentar criar um template sem preencher o nome
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        E eu acesso a página de gerenciamento de templates
        Quando seleciono a opção de criar um novo template
        E deixo o campo "Nome do template" em branco
        E adiciono uma questão do tipo "Texto" com o enunciado "Comentários gerais"
        E clico no botão "Criar"
        Então o sistema deve exibir a mensagem de erro "O nome do template é obrigatório"
        E o template não deve ser salvo

    Cenário: [Triste] Tentar criar um template sem adicionar nenhuma questão
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        E eu acesso a página de gerenciamento de templates
        Quando seleciono a opção de criar um novo template
        E preencho o campo "Nome do template" com "Template Vazio"
        E clico no botão "Criar" sem adicionar nenhuma questão
        Então o sistema deve exibir a mensagem de erro "O template deve conter ao menos uma questão"
        E o template não deve ser salvo

    Cenário: [Triste] Tentar criar uma questão do tipo Radio sem adicionar opções de resposta
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        E eu acesso a página de gerenciamento de templates
        Quando seleciono a opção de criar um novo template
        E preencho o campo "Nome do template" com "Avaliação Semestral"
        E adiciono uma questão do tipo "Radio" com o enunciado "Como você avalia a disciplina?" sem opções de resposta
        E clico no botão "Criar"
        Então o sistema deve exibir a mensagem de erro "Questões do tipo Radio devem ter ao menos uma opção de resposta"
        E o template não deve ser salvo

    Cenário: [Triste] Tentar criar uma questão com enunciado vazio
        Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
        E eu acesso a página de gerenciamento de templates
        Quando seleciono a opção de criar um novo template
        E preencho o campo "Nome do template" com "Avaliação de Turma"
        E adiciono uma questão do tipo "Texto" com o enunciado em branco
        E clico no botão "Criar"
        Então o sistema deve exibir a mensagem de erro "O enunciado da questão é obrigatório"
        E o template não deve ser salvo

    Cenário: [Triste] Participante tenta acessar a página de gerenciamento de templates
        Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
        E eu acesso a página de gerenciamento de templates
        Então o sistema deve exibir a mensagem "Você não tem permissão para acessar esta página"
        E eu devo ser redirecionado para a página inicial do meu perfil
