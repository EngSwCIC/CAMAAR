language: pt
Funcionalidade: Fazer Login Menu Inicial

Como usuário Camaar Unb
Então eu posso logar na Menu Inicial
Eu desejo navegar no aplicativa Cammar Unb 

Dado que estou na interface Caamar Unb
Quando eu procuro logar
Então deveria estar acessando o aplicativo Cammar Unb

Cenario: Logar Pagina Inicial de Login dados nao conferem Caminho ruim
Quando estou autenticado e sou cadastrado
Entao deve ver os campo "password", "user" e "email"
Eu prencho dados com meu usuario minha senha e meu email  
Quando a identificacao do usuario nao consegue ser feita por não conferir user email e password
Entao dados nao conferem 
E exibe mensagem " Dados não conferem! Procure o administrador do sistema "

Cenario: Logar teste falso na Menu Inicial de Login dados 
Quando estou  autenticado e sou cadastrado mas tento entrar com falso user
Entao deve ver os campo "password", "user" e "email"
Eu prencho dados com  usuario teste falso, minha senha e meu email  
Quando a identificacao do usuario consegue ser feita por não conferir  email e password
Entao dados nao conferem 
E exibe mensagem " Dados não conferem ! Usuario Incorreto "

Cenario: Logar Pagina Inicial de Login Caminho bom
Quando estou estou autenticado mas sou cadastrado
Entao deve ver os campo "password", "user" e "email"
Eu prencho dados com meu usuario minha senha e meu email  
Quando a identificacao do User esta correta 
Entao identifica por ocupacao 
Quando ocupacao é administrador 
Entao vou para rota tela administrador
Quando ocupação é professor
Entao vou para rota tela administrador
Quando ocupação é aluno
Entao vou para rota tela aluno preeencher formulário de pesquisa
