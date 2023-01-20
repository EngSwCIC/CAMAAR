#language: pt
Funcionalidade: Acessar página onde é possível importar dados do SIGAA 

Cenario: Página inicial após Login
Dado que estou autenticado como coordenador
Quando clicar no botão "Importar do SIGAA"
Então eu devo acessar a rota "/import" visualizar página com os relatórios
E devo visualizar página onde é possível importar informações do SIGAA