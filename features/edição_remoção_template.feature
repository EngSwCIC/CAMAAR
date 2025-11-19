@testes
@admin
@edicao_exclusao_template


Funcionalidade: edição e deleção de templates #112 
Eu como Administrador
Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
A fim de organizar os templates existentes

   Contexto:
        Dado que um 'administrador' está logado
        E está na tela 'Templates'
        E o banco de dados está 'carregado'


@112.1
    Cenário: 112.1 - Quando um administrador tenta editar um template, deve salvar as alterações corretamente.   

     	Quando o botão de edição de um formulário é selecionado
        Entao deve ser possível visualizar o template selecionado
        Quando o template é editado 'corretamente'
        Entao deve salvar o template no banco de dados

@112.2
    Cenário: 112.2 - Quando um administrador tenta editar  um template mas preenche os dados incorretamente, não deve alterar os templates do banco de dados.
        Quando o botão de edição de um formulário é selecionado
        Entao deve ser possível visualizar o template selecionado
        Quando o template é editado 'incorretamente'
        Entao não deve alterar o template no banco de dados


    @112.3
    Cenário: 112.3 - Quando um administrador seleciona o botão de excluir um template, o template deve ser removido do banco de dados.
        Quando o botão de remoção de um template é selecionado
        Entao o template deve ser excluído do banco de dados


@112.4 
Cenário: 112.4 - Quando um administrador tenta editar um template, mas não salva as mudanças, não deve alterar o banco de dados
	Quando o botão de edição de um formulário é selecionado
        Entao deve ser possível visualizar o template selecionado
        Quando a edição de templates não é bem sucedida
        Entao não deve salvar o template no banco de dados
