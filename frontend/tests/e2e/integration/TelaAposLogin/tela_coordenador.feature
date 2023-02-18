#language: pt
Funcionalidade: Acessar página com questionários

Cenario: Página inicial após Login
Dado que estou autenticado como coordenador
E vou para a rota "/home"
Quando clicar no botão "Questionários"
Então eu devo visualizar página com os questionários