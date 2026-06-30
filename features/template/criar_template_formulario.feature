# language: pt
Funcionalidade: Criar template de formulário
    Como um Administrador
    Eu quero criar um template de formulário contendo as questões do formulário
    A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

    Contexto:
        Dado que estou logado como um usuário Administrador

    @cenario_feliz
    Cenário: Criar um template com sucesso (Cenário Feliz)
        Dado que estou na página de criação de templates
        Quando preencho o campo "Título" com "Avaliação Docente Padrão"
        E adiciono a questão "Como você avalia a didática do professor?" do tipo "Múltipla Escolha"
        E clico em "Salvar Template"
        Então devo ver a mensagem de sucesso "Template criado com sucesso!"
        E o template "Avaliação Docente Padrão" deve constar no sistema

    @cenario_triste
    Cenário: Tentar criar um template sem título (Cenário Triste - Título em Branco)
        Dado que estou na página de criação de templates
        Quando preencho o campo "Título" com ""
        E adiciono a questão "O conteúdo foi totalmente coberto?" do tipo "Texto"
        E clico em "Salvar Template"
        Então devo ver a mensagem de erro "Nome do Template não pode ficar em branco"
        E nenhum template novo deve ser salvo no sistema

    @cenario_triste
    Cenário: Tentar criar um template sem perguntas (Cenário Triste - Sem Perguntas)
        Dado que estou na página de criação de templates
        Quando preencho o campo "Título" com "Avaliação Docente Padrão"
        E clico em "Salvar Template"
        Então devo ver a mensagem de erro "O template deve ter ao menos uma pergunta"
        E nenhum template novo deve ser salvo no sistema