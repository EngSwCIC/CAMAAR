# Grupo - Camaar - G1
## Participantes: 
-Willyan Marques 
-Marcos Paulo
-Arthur Delpino
-Caio Yuri
-João Pedro Gomes - 221006351

## Scrum Master: Willyan Marques
## Serão desenvolvidas as 16 issues, com base no nossa estilização presente em [Figma - Willyan Marques](https://www.figma.com/design/kIW8LmzqajgAQVigrLX21y/Camaar-G01?node-id=0-1&t=H1Mo40dyNMOK5nv3-0) e no nosso modelo entidade-relacionamento.

## Divisão das Features:
- Features de Autenticação (Auth): João Pedro Gomes
- Features de Exportação e Importação (Io): Marcos Paulo
- Features de Formulários: Willyan Marques e Arthur Delpino
- Features de Templates: Willyan Marques e Caio Yuri
- A política de branch se baseou em criar branches a partir de sprint-1 para desenvolvimento de cada feature, e, ao final do desenvolvimento, promover um pull request para a branch sprint-1

# Features
## Auth
### Sistema de Login #104 - login.feature - 
### Redefinição de senha #107 - password_reset.feature
### Sistema de definição de senha #105 - signup.feature
## Forms
### Responder formulário #99 - submit_form.feature
## Io
### Gerar relatório do administrador #101 - exports_results.feature
### Importar dados do SIGAA #98 - import_data.feature
### Cadastrar usuários do sistema #100 - import_data.feature
### Atualizar base de dados com os dados do SIGAA #108 - update_data.feature
## Templates
### Criar template de formulário #102 - create_template.feature
### Edição e deleção de templates #112 - delete_template.feature e edit_template.feature
### Criar formulário de avaliação #103 - share_template.feature
### Criação de formulário para docentes ou dicentes #113 - select_template.feature
### Sistema de gerenciamento por departamento #106 - departments.feature
## Visualizations
### Visualização de formularios para responder #109 - forms_page.feature
### Visualização de resultados dos formulários #110 - results_page.feature
### Visualização dos templates criados #111 - templates_page.feature

# Figma (base do Frontend):
[Figma - Willyan Marques](https://www.figma.com/design/kIW8LmzqajgAQVigrLX21y/Camaar-G01?node-id=0-1&t=H1Mo40dyNMOK5nv3-0)

# Features:
- Autenticação de usuários
- Formulários
    - Visualização de formulários
    - Registro de respostas
- Dashboards de admin
- Serviços de admin
    - Importação de dados (JSON fornecido)
    - Gerenciamento de formulários (CRUD)
    - Envio de formulários
    - Resultados
        - Gráficos
        - CSV 

# Histórias de usuário
## Como um usuário qualquer eu quero
1. Redefinir minha senha
2. Fazer login com a senha que cadastrei

## Como professor/aluno (user) eu quero
1. Me cadastrar no site 
2. Preencher formulários das turmas que participo
3. Visulizar todos formulários associados a mim

## Como aluno (user)
1. Sair de turmas que retirei/tranquei

## Como professor (user)
...

## Como coordenador (admin) eu quero
1. Importar dados das turmas e cadastrá-las no banco de dados
2. Ter acesso a um dashboard em que eu possa importar dados das turmas, editar e enviar formulários e salvar as respostas de formulários 
4. Criar formulários para professores/alunos
5. Editar formulários
6. Apagar formulários
7. Pesquisar formulários a partir de informações presente neles (nome, semestre, turma, professor, etc.)
8. Enviar um formulário para turmas selecionadas por mim (opções de filtro como professor, semestre)
9. Agendar o envio de um formulário
10. Visualizar templates de formulários criados por mim
11. Visualizar formulários que foram enviados
12. Aplicar filtros na visualização de formulários templates
13. Aplicar filtros na visualização de formulários enviados
14. Baixar as respostas de um formulário em um arquivo CSV
15. Visulizar gráficos das respostas de um formulário enviado
