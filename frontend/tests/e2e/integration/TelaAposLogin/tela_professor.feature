#language: pt

Funcionalidade: Acesssar página com relatórios

Cenario: Página inicial após login
Dado que estou autenticado como professor
Quando clicar no botão "relatórios"
Então devo visualizar a página contendo os relátorios dos questionários dos alunos
E eu deveria ver todos os relatórios feitos