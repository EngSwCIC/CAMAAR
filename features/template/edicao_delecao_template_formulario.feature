# language: pt
Funcionalidade: Edição e deleção de templates
    Como um Administrador
    Eu quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
    A fim de organizar os templates existentes

    Contexto:
        Dado que estou logado como um usuário Administrador
        E que existem os seguintes templates criados por mim no sistema:
        | titulo                     | descricao                         | versao |
        | Avaliação Docente Padrão   | Template para avaliar professores | 1      |
        | Feedback de Infraestrutura | Avaliação das salas de aula       | 1      |

    @cenario_feliz
    Cenário: Administrador edita o título de um template com sucesso (Cenário Feliz - Edição de Título)
        Dado que estou na página de listagem de templates
        Quando clico em "Editar" no template "Avaliação Docente Padrão"
        E preencho o campo "Título" com "Avaliação de Didática Docente"
        E clico em "Atualizar Template"
        Então devo ver a mensagem de sucesso "Template atualizado com sucesso!"
        E o template deve constar com o título "Avaliação de Didática Docente" no sistema
    
    @cenario_feliz
    Cenário: Administrador edita a descrição de um template com sucesso (Cenário Feliz - Edição de Descrição)
        Dado que estou na página de listagem de templates
        Quando clico em "Editar" no template "Feedback de Infraestrutura"
        E preencho o campo "Descrição" com "Avaliação das condições das salas de aula e laboratórios"
        E clico em "Atualizar Template"
        Então devo ver a mensagem de sucesso "Template atualizado com sucesso!"
        E o template deve constar com a descrição "Avaliação das condições das salas de aula e laboratórios" no sistema

    @cenario_feliz
    Cenário: Administrador deleta um template que não possui formulários vinculados (Cenário Feliz - Deleção de Template)
        Dado que estou na página de listagem de templates
        E o template "Feedback de Infraestrutura" não possui nenhum formulário associado
        Quando clico em "Deletar" no template "Feedback de Infraestrutura"
        Então devo ver a mensagem de sucesso "Template excluído com sucesso!"
        E o template "Feedback de Infraestrutura" não deve mais constar no sistema

    @cenario_triste
    Cenário: Tentar deletar um template que já possui formulários criados (Cenário Triste — Regra de Negócio)
        Dado que estou na página de listagem de templates
        E existe um formulário ativo gerado a partir do template "Avaliação Docente Padrão"
        Quando clico em "Deletar" no template "Avaliação Docente Padrão"
        Então devo ver a mensagem de erro "Não é possível deletar este template pois ele já possui formulários de avaliações vinculados."
        E o template "Avaliação Docente Padrão" deve continuar intacto no sistema