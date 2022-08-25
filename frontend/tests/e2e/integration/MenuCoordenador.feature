#language: pt

Funcionalidade: Tela do Menu do Coordenador 

Cenário: Clicar em questionários como Coordenador (Maria)
Dado que estou na página do Menu Principal
Devo clicar em "Abrir Menu Lateral"
Quando clicar em "Questionários" 
Deve abrir tela com escolha "Professor" e "Coordenador"
Quando clicar em Professor
Então deve mostrar os questionários de professor do Coordenador

@mockSemQuestionarios
Cenário: Clicar em questionários como Coordenador Triste (Maria)
Dado que estou na página do Menu Principal
Devo clicar em "Abrir Menu Lateral"
Quando clicar em "Questionários" 
Deve abrir tela com escolha "Professor" e "Coordenador"
Quando clicar em Professor
E não retornar nenhum questionário
Então deve exibir mensagem de erro "Sem questionários de PROFESSOR"


Cenário: Clicar em questionários como Coordenador (Maria)
Dado que estou na página do Menu Principal
Devo clicar em "Abrir Menu Lateral"
Quando clicar em "Questionários" 
Deve abrir tela com escolha "Professor" e "Coordenador"
Quando clicar em Coordenador
Então deve mostrar os questionários de todas as turmas

@mockSemQuestionarios
Cenário: Clicar em questionários como Coordenador Triste (Maria)
Dado que estou na página do Menu Principal
Devo clicar em "Abrir Menu Lateral"
Quando clicar em "Questionários" 
Deve abrir tela com escolha "Professor" e "Coordenador"
E não retornar nenhum questionário
Então deve exibir mensagem de erro "Sem questionários de COORDENADOR"


Cenário: Clicar em relatórios como Coordenador (Maria)
Dado que estou na página do Menu Principal
Devo clicar em "Abrir Menu Lateral"
Quando clicar em "Relatórios" 
Deve abrir tela com página com todos os relatórios 

@mockSemQuestionarios
Cenário: Clicar em relatórios como Coordenador Triste(Maria)
Dado que estou na página do Menu Principal
Devo clicar em "Abrir Menu Lateral"
Quando clicar em "Relatórios" 
E não retornar nenhum questionário 
Então deve exibir mensagem de erro "SEM RELATÓRIOS"


Cenário: Clicar em criar questionário como Coordenador (Maria)
Dado que estou na página do Menu Principal
Devo clicar em "Abrir Menu Lateral"
Quando clicar em "Criar Questionário" 
Deve abrir tela com página para criar relatórios

3.4)Cenário: Importar dados do sig (Maria e Pericles)

Como usuário Camaar Unb e Coordenador da Unb
Então posso navegar pelo Menu do Coordenador
Eu desejo importar dados do sig 'https://sig.unb.br/sigaa/'

Dado que estou na interface Caamar Unb 
Quando eu estou na Menu Principal e acesso com password de Coordenado
Então devo estar acessando o aplicativo Cammar Unb coordenador

Cenário: Importar Turmas do SIGAA como Coordenador Dados de seleção não conferem Caminho ruim
Dado que estou na página do Menu Coordenador
Quando clicar em "Importar Turmas do SIGAA "
Devo confirmar login no sistema sig  'https://sig.unb.br/sigaa/'
Entao devo ver os campo "password", "user" do sistema sig
Então devo prencher os dados com meu usuario minha senha 
Quando conexao correta exibe mensagem "Usuario Conectado ao sistema siga"
Entao exibe campo de seleção "Disciplina",  o campo "Turma" e o campo "semestre"
Entao devo preencher campos selecionados.
E clicar no botão "confirma seleção"
Quando a seleção preenchida nos campos não confere 
Entao exibe mensagem " Dados não conferem! Confira seleção "
Entao exibe mensagem " Deseja retorna a o menu principal log out ou nova seleção "
Então exibe campo retorno ao menu principal,  campo opção de log out  ou nova seleção de turmas
Então clico em campo retorno ao menu principal,  ao campo log out do Menu Principal ou nova seleção de turmas


Cenário: Importar Turmas do SIGAA como Coordenador Bom caminho
Dado que estou na página do Menu Coordenador
Quando clicar em "Importar Turmas do SIGAA "
Devo confirmar login no sistema sig  'https://sig.unb.br/sigaa/'
Entao devo ver os campo "password", "user" do sistema sig
Então devo prencher os dados com meu usuario minha senha 
Quando conexao correta exibe mensagem "Usuario Conectado ao sistema siga"
Entao exibe campo de seleção Disciplina ,  o campo Turma e o campo semestre
Entao devo preencher campos selecionados.
E clicar no botão "confirma seleção"
E esperar importar turmas
Então eu devo ver uma notificação de "Turmas selecionadas importadas com sucesso."
Entao exibe mensagem " Deseja retorna a o menu principal "
Então exibe campo retorno ao menu principal,  campo opção de log out  ou nova seleção de turmas
Então clico em campo retorno ao menu principal,  ao campo log out do Menu Principal ou nova seleção de turmas.
