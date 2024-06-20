# Auth

Features que envolvem login, registro, redefinição de senha, proteção de rotas e demais processos relacionados aos usuários e à segurança do sistema

## login

**Model**

**View**

**Controller**

## password_reset

**Model**

**View**

**Controller**

## signup_user

**Model**

**View**

**Controller**

# Forms

Features que envolvem criação, submissão e envio de formulários

## create_form

**Model**

**View**

**Controller**

## student_submit_form

**Model**

**View**

**Controller**

## teacher_submit_form

**Model**

**View**

**Controller**

# IO

Features relacionadas à importação de dados para o sistema e à exportação de arquivos (xlms, gráficos, pdf, etc)

## export_results

**Model**

**View**

**Controller**

## import_data

**Model**

**View**

**Controller**

## update_data

**Model**

**View**

**Controller**

# Templates

Features realacionadas ao CRUD de templates e questões

## create_edit_template

**Model**

- Coordinator
- Template
- TemplateQuestion

**View**

- /templates/edit.html.erb
- /templates/index.html.erb
- /template_questions/edit.html.erb
- /template_questions/new.html.erb

**Controller**

- /templates_controller.rb
- /templates_questions_controller.rb

**Explicação**

Para criar um template, um coordenador precisa seguir a opção "Templates" na sidebar, ir pra página de templates e precionar "Adicionar Template". Quando você adiciona um template, você cria um template marcado como "draft" na database.

Você irá ser redirecionado para página de editar template, onde você poderá adicionar questões a ele e modificar seu nome e tipo ("discente" ou "docente").

Para salvar os dados você precisa ter criado pelo menos uma questão.

**Bugs**

Por conta da relação entre as models de template e questões, seria necessário a criação de um formulário aninhado para registrar os dados em ambas models. Como isso é algo relativamente complexo e o tempo era extremamente curto, optamos por tentar refatorar a criação de templates futuramente.
Na implementação atual, embora funcional, precisamos primeiro CRIAR um template para só então criar suas perguntas. Adicionamos o atributo "draft" como uma forma de saber se ele possui ou não perguntas e se pode ser usado na criação de formulários.

## delete_template

**Model**

Coordinator
Template
TemplateQuestion

**View**

- /templates/edit.html.erb
- /templates/index.html.erb

**Controller**

- /templates_controller.rb

**Explicação**

Um template pode ser deletado a partir o botão de delete presente no seu card na página de "templates", ou pode ser deletado pelo botão de delete da página de edição do template.

Deletar um template também deleta as questões relacionadas a ele, mas mantém os forms criados a partir dele.

# Visualization

Features que descrevem as páginas do site com foco na visualização, e não necessariamente nas funcionalidades das páginas

## classes_page

**Model**

**View**

**Controller**

Lista todas

## departments_page

**Model**

**View**

**Controller**

## forms_page

**Model**

**View**

**Controller**

## results_page

**Model**

**View**

**Controller**

## templaes_page

**Model**

**View**

**Controller**
