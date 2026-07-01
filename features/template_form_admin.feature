# language: pt

@javascript
Funcionalidade: Gerar template de formulário
    Como um Administrador
    Quero criar um template de formulário contendo as questões do formulário
    A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

    Contexto:
        Dado que existem templates de avaliação cadastrados no sistema
        E que estou logado como Administrador
        E estou na página "Gerenciamento"
        E clico no botão "Editar Templates"
        Então sou redirecionado para a página "Gerenciamento - Templates"
        E vejo os templates existentes exibidos em cards com nome e semestre
        E cada card possui os ícones de editar e excluir
        E vejo um card com o símbolo "+" para criar um novo template

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Abrir modal de criação de novo template
        Quando clico no card "+"
        Então um modal é exibido com o campo "Nome do template"
        E o modal contém ao menos uma questão com os campos "Tipo", "Texto" e "Opções"
        E vejo o botão "Criar"

    Cenário: Criar um novo template com questão do tipo Radio
        Quando clico no card "+"
        E preencho o campo "Nome do template" com "Avaliação Engenharia de Software"
        E seleciono o tipo "Radio" na "Questão 1"
        E preencho o campo "Texto" da "Questão 1" com "Como você avalia a didática do professor?"
        E preencho o campo "Opções" da "Questão 1" com "Muito bom"
        E clico no botão "+" dentro da "Questão 1" para adicionar mais uma opção
        E preencho a nova opção com "Bom"
        E clico no botão "Criar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Template criado com sucesso"
        E o template "Avaliação Engenharia de Software" aparece na listagem de cards

    Cenário: Criar um novo template com questão do tipo Texto
        Quando clico no card "+"
        E preencho o campo "Nome do template" com "Avaliação Aberta"
        E seleciono o tipo "Texto" na "Questão 1"
        E preencho o campo "Texto" da "Questão 1" com "Deixe seu comentário sobre o professor"
        E clico no botão "Criar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Template criado com sucesso"
        E o template "Avaliação Aberta" aparece na listagem de cards

    Cenário: Criar template com múltiplas questões de tipos diferentes
        Quando clico no card "+"
        E preencho o campo "Nome do template" com "Avaliação Completa"
        E seleciono o tipo "Radio" na "Questão 1"
        E preencho o campo "Texto" da "Questão 1" com "Avalie o desempenho geral"
        E preencho o campo "Opções" da "Questão 1" com "Ótimo"
        E clico no botão "+" roxo para adicionar uma nova questão
        E seleciono o tipo "Texto" na "Questão 2"
        E preencho o campo "Texto" da "Questão 2" com "Comentários adicionais"
        E clico no botão "Criar"
        Então o modal é fechado
        E o template "Avaliação Completa" é salvo com 2 questões

    Cenário: Editar um template existente
        Dado que existe o card do template "Avaliação Engenharia de Software" na listagem
        Quando clico no ícone de editar do template "Avaliação Engenharia de Software"
        Então o modal de edição é exibido com os dados atuais do template preenchidos
        Quando altero o campo "Nome do template" para "Avaliação Engenharia de Software Revisada"
        E clico no botão "Criar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Template atualizado com sucesso"
        E o card "Avaliação Engenharia de Software Revisada" aparece na listagem

    Cenário: Excluir um template existente
        Dado que existe o card do template "Avaliação Antiga" na listagem
        Quando clico no ícone de excluir do template "Avaliação Antiga"
        Então vejo uma mensagem de confirmação "Deseja excluir o template Avaliação Antiga?"
        Quando confirmo a exclusão
        Então o card "Avaliação Antiga" é removido da listagem

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Tentativa de criar template sem preencher o nome
        Quando clico no card "+"
        E deixo o campo "Nome do template" em branco
        E preencho o campo "Texto" da "Questão 1" com "Como você avalia o professor?"
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "O nome do template é obrigatório"

    Cenário: Tentativa de criar template sem preencher o texto de uma questão
        Quando clico no card "+"
        E preencho o campo "Nome do template" com "Template Incompleto"
        E deixo o campo "Texto" da "Questão 1" em branco
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "O texto da questão é obrigatório"

    Cenário: Tentativa de criar template do tipo Radio sem nenhuma opção
        Quando clico no card "+"
        E preencho o campo "Nome do template" com "Template Inválido"
        E seleciono o tipo "Radio" na "Questão 1"
        E preencho o campo "Texto" da "Questão 1" com "Avalie o professor"
        E deixo o campo de opções "Opções" em branco
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "Questões do tipo Radio devem ter ao menos uma opção"

    Cenário: Tentativa de acesso à tela de Templates por usuário não administrador
        Dado que estou logado como Discente
        Quando tento acessar a página "Gerenciamento - Templates"
        Então sou redirecionado para o painel do usuário
        E vejo a mensagem de erro "Acesso não autorizado"
