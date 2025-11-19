Funcionalidade: Criar template de formulário  

Cenário: Criação de template com dados válidos (Feliz)
    Dado que estou na página de criação de templates
    E preencho o campo "Nome do template" com "Avaliação 2024"
    E adiciono um tipo de questão de múltipla escolha
    E adiciono um tipo de questão discursiva
    Quando clico no botão "Salvar Template"
    Então o sistema deve exibir a mensagem "Template criado com sucesso"
    E o template deve ser salvo no banco de dados

Cenário: Tentativa de criação com título vazio (Triste)
    Dado que estou na página de criação de templates
    E deixo o campo "Título" vazio
    E adiciono tipos de questões válidas
    Quando clico no botão "Salvar Template"
    Então o sistema deve exibir a mensagem de erro "O campo Título é obrigatório"
    E o template não deve ser salvo

Cenário: Tentativa de criação sem questões (Triste)
    Dado que preencho o título corretamente
    E não adiciono nenhum tipo de questão ao template
    Quando clico no botão "Salvar Template"
    Então o sistema deve exibir o erro "O template deve conter pelo menos uma questão"
    E o template não deve ser salvo
