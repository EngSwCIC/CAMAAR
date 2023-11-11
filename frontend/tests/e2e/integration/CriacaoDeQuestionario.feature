Funcionalidade: Criar novo questionário 

    Contexto: 
        Como um coordenador de curso
        Dado que estou na página de criação de questionário

    Cenário: Alterar título do questionário
        Quando eu clicar no título principal do questionário
        E digitar um novo título
        Então título do questionário deve ser atualizado.
    Pontos: 2

    Cenário: Criação de nova pergunta
        Quando eu clicar no botão de "criar pergunta"
        Então a pergunta atual deve ser guardada e um novo card para uma pergunta é criado
    Pontos: 2

    Cenário: Escolher tipagem da pergunta
        Quando clicar no "botão de tipo da pergunta"
        Então deve aparecer uma seleção dos tipos possíveis de pergunta
        E deverá ser mudado o tipo de pergunta atual.
    Pontos: 2

    Cenário: Salvar questionário (happy path)
        E todas as perguntas estão devidamente preenchidas
        Quando clicar em "salvar"
        Então o questionário será salvo no BD
        E será mostrado uma mensagem de sucesso
    Pontos: 3

    Cenário: Salvar questionário (sad path)
        E alguma pergunta não está devidamente preenchida
        Quando clicar em "salvar"
        Então o questionário não será salvo no BD
        E será mostrado uma mensagem de erro
    Pontos: 3
    Cenário: Excluir pergunta
    E alguma pergunta está preenchida
    Quando eu clicar em "excluir pergunta"
    Então a pergunta será excluída
Pontos: 3

Cenário: Editar pergunta do questionário
    E alguma pergunta está preenchida
    Quando eu clicar em "editar pergunta"
    Então a pergunta poderá ser modificada
Pontos: 2
