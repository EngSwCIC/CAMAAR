
@testes  
@admin  
@visualizacao_formularios  
@relatorios

Funcionalidade: Visualização de resultados dos formulários #110  
Eu como: Administrador  
Quero: visualizar os formulários criados  
A fim de: poder gerar um relatório a partir das respostas  

Contexto:  
    Dado que um 'administrador' está logado  
    E está na tela 'Relatórios'  
    E o banco de dados está 'operacional'



@110.1  
Cenário: 110.1 - Quando um administrador visualiza formulários existentes, deve carregar a lista corretamente  
    Quando o administrador acessa a tela de visualização de formulários  
    Então o sistema deve carregar todos os formulários criados  
    E deve exibir: título, data de criação, quantidade de respostas e status  
    E deve permitir a seleção para visualização detalhada  

@110.2  
Cenário: 110.2 - Quando um administrador tenta visualizar formulários mas não existem formulários criados  
    Quando o administrador acessa a tela de visualização de formulários  
    Então o sistema deve exibir a mensagem "Nenhum formulário encontrado"  
    E deve oferecer a opção para criar um novo formulário  

@110.3  
Cenário: 110.3 - Quando um administrador tenta visualizar formulários mas ocorre erro no banco de dados  
    Quando o administrador acessa a tela de visualização de formulários  
    Então o sistema deve detectar a falha de conexão com o banco de dados  
    E deve exibir a mensagem "Erro temporário no sistema. Tente novamente em alguns instantes."  
    E deve gerar logs de erro para análise técnica  
    E deve oferecer a opção de tentar novamente  

@110.4  
Cenário: 110.4 - Quando um administrador aplica filtros na visualização de formulários  
    Quando o administrador aplica filtros por data, status ou tipo de formulário  
    E utiliza a funcionalidade de busca por título  
    Então o sistema deve retornar os resultados filtrados corretamente  
    E deve manter os filtros aplicados durante a sessão  

@110.5  
Cenário: 110.5 - Quando um administrador gera relatório a partir das respostas  
    Quando o administrador seleciona um formulário específico  
    E solicita a geração de relatório  
    Então o sistema deve compilar todas as respostas do formulário selecionado  
    E deve exportar o relatório no formato solicitado (PDF/Excel)  
    E deve disponibilizar o download do arquivo gerado  

@110.6  
Cenário: 110.6 - Quando um administrador tenta visualizar formulários mas ocorre timeout  
    Quando o administrador acessa a tela de visualização de formulários  
    E a requisição excede o tempo limite  
    Então o sistema deve exibir indicador de carregamento  
    E após o timeout deve oferecer opção de recarregar os dados  
    E deve manter a interface responsiva  

@110.7  
Cenário: 110.7 - Quando um administrador sem permissões tenta acessar a visualização  
    Quando um usuário sem permissões de administrador acessa a funcionalidade  
    Então o sistema deve redirecionar para a página de login  
    Ou deve exibir mensagem de "Permissão negada"  



  
