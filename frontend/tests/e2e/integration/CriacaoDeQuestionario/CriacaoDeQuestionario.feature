#language: pt
Funcionalidade: Criar novo questionário
    Como coordenador
    Eu quero conseguir criar um questionário

Contexto:
    Dado que estou na rota "/create-survey/"
    Então eu deveria ver o campo "Título"
    E eu deveria ver o botão "Adicionar Pergunta"
    E eu deveria ver o botão "Salvar"

    Cenário: Alterar título do questionário
        Quando eu clicar no título principal do questionário
        E digitar "Questionário"
        Então título do questionário deve ser atualizado para "Questionário".

    Cenário: Criação de nova pergunta
        Quando eu clicar no botão de "Adicionar Pergunta"
        Então eu devo ver um campo com "Título da Pergunta",
        E eu devo ver um campo de "Tipo da Pergunta"
        E eu devo ver o campo de "Alternativa da pergunta"

    Cenário: Deletar pergunta
        Dado que eu tenho uma pergunta criada
        Quando eu clicar no botão de "Deletar Pergunta"
        Então a pergunta deve ser deletada

