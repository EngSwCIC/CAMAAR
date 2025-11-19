Funcionalidade: Visualização dos templates criados 

Cenário: Visualizar lista de templates existentes (Feliz)
    Dado que existem templates salvos no sistema
    Quando eu acesso a página "Templates"
    Então devo ver uma lista contendo todos os templates criados
    E devo ver as opções de "Editar" e "Deletar" para cada template da lista

Cenário: Visualizar lista vazia (Triste)
    Dado que não existe nenhum template salvo no sistema
    Quando eu acesso a página "Templates"
    Então o sistema deve exibir a mensagem "Nenhum template foi criado"
    E a lista de visualização deve estar vazia
