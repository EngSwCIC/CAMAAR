# Grupo - Camaar - G1
## Participantes: 
- Willyan Marques - 221020940
- Marcos Paulo - 221020889
- Arthur Delpino - 221002094
- Caio Yuri - 221002011
- João Pedro Gomes - 221006351

## Scrum Master: Willyan Marques
## Serão desenvolvidas as issues presentes em nosso github, com base na nossa estilização presente em [Figma - Willyan Marques](https://www.figma.com/design/kIW8LmzqajgAQVigrLX21y/Camaar-G01?node-id=0-1&t=H1Mo40dyNMOK5nv3-0) e no nosso modelo entidade-relacionamento.

## Ambiente de desenvolvimento
O projeto foi desenvolvido sumariamente em ambiente linux, tendo sido testados os seguintes sistemas operacionais com êxito:

- 6.8.9-arch1-2
- 6.6.9-1kali1

Além disso, para a execução dos testes com rspec, é necessário que o navegador Firefox esteja devidamente instalado, dado ao fato de que o webdriver utilizado - selenium - utiliza o browser firefox em nosso ambiente de testes.

As versões do ruby testadas com êxito foram ruby 3.3.0 e ruby 3.3.1.
## Divisão do desenvolvimento
- Willyan Marques: renderização dinâmica de templates, frontend, backend e modelo entidade relacionamento, gráfico com kickchart e exportação em csv, testes em cucumber e correção e revisão de código; pair programming com os demais membros.
- João Pedro Gomes: autenticação com o Devise, frontend, gestão de configuração de css, javascript e bibliotecas externas em ambiente rails,testes em rspec e cucumber e correção e revisão de código; pair programming com os demais membros.
- Marcos Paulo: MVC das páginas de envio e import, bem como seus respectivos testes; pair programming com os demais membros.
- Arthur Delpino: MVC das páginas de turmas-user e de formulários-user a serem respondidos, bem como seus respectivos testes; pair programming com os demais membros.
- Caio Yuri: MVC das páginas de resultados-admin e pair programming com os demais membros.

# Guia para o usuário

## Setup de ambiente ##
- bundle install (para instalar as gems necessárias)
- bundle exec cucumber features/ (para executar os testes das features em cucumber)
- bundle exec rspec spec/ (para executar os testes em rspec)
- bundle exec rails db:reset (para executar as migrações necessárias no banco de dados e ativar a seed)
- bundle exec rails s (para ativar o servidor)
- localhost:3000 (para acessar a página root do sistema)
- localhost:3000/mails (para acessar o servidor de emails fictício)

## Guia de uso ##
Ao acessar o sistema como administrador/coordenador, utilize a seed pré-existente a partir de algum administrador conhecido (ex: email:admin.cic@gmail.com, password:admin123)· Em seguida, vá para a página de importar dados, e importe o arquivo json "class_members.json", para enviar um email solicitando que os usuários se registrem.Ao efetuar a operação de importar dados com sucesso, os usuários já podem se registrar.Se for necessário, podem ser adicionados departamentos e turmas por departamento, bastando importar o respectivo aquivo json, e respeitando as regras de integridade pré-existentes.

Se você for um usuário registrado no json, acesse o servidor de emails localhost:3000/mails (fictício) e procure seu endereço de email. Nele, ao clickar no link de "Registrar", você será submetido a uma página de cadastro de usuário, que só será finalizado se, após a submissão do registro, você confirmar o cadastro por meio de confirmação de link através de um novo email enviado.

Sendo um coodenador/administrador, você pode criar templates com questões em texto e em múltipla escolha. Se quiser enviar um template como um formulário, acesse a página de envio e selecione a turma desejada, selecione a opção de formulário para aluno e/ou professor e efetue a operação.Após receber alguma resposta de algum aluno, a página de respostas conterá o formulário, com as respostas em csv e um gráfico de setores. Ao clickar no nome do formulário, poderá visualizar as respostas também.

Sendo um aluno ou professor cadastrado como usuário no sistema, você pode visualizar os formulários pendentes e respondidos, bem como verificar suas respostas. 

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
