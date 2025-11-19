Funcionalidade: Edição e Deleção de Templates

Cenário: Edição de nome de template usado em formulário antigo (Feliz)
    Dado que tenho o template "Avaliação A" associado a um formulário já respondido
    Quando eu edito o nome do template para "Avaliação A - Revisada"
    E clico no botão "Salvar"
    Então o sistema deve atualizar o template para "Avaliação A - Revisada"
    E os formulários antigos criados com o template "Avaliação A" não devem sofrer alteração

Cenário: Deleção de um template existente (Feliz)
    Dado que seleciono um template existente na lista
    Quando clico em "Deletar"
    E aparece um pop-up com o texto "Você tem certeza que deseja deletar este template?"
    E confirmo a ação clicando no botão "Confirmar"
    Então o template deve ser removido da lista de visualização
    E não devo ver ele no gerenciamento de templates

Cenário: Edição com caracteres inválidos no título (Triste)
    Dado que estou na tela de edição de um template
    Quando preencho o campo "Título" com caracteres não permitidos
    Então o sistema deve exibir a mensagem "Formato de título inválido"
    E aparece uma mensagem de texto indicando quais caracteres não são permitidos
    E as alterações não devem ser salvas
