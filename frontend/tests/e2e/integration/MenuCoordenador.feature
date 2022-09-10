#language: pt
Funcionalidade: Menu de Coordenador

Cenario: Pagina de Menu de Coordenador
Dado que nao estou autenticado
Então eu vou para a rota "/"
E eu devo ver "Coordenador"
Então eu deveria ver o botão "Questionários (como professor)"
E eu deveria ver o botão "Relatórios das turmas (como coordenação)"
E eu deveria ver o botão "Importar turmas do SIGAA"
