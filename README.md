
## login

**Model**

User
Admin

**View**

- /admins/sessions/new.html.erb
- /users/sessions/new.html.erb

**Controller**

- /users/sessions_controller.rb
- /admins/sessions_controller.rb

**Explicação**

A autenticação/login de usuário e admin é feito por meio de métodos herdados por controllers nativas do Devise,uma gem de autenticação de email e senha.

Um usuário (aluno e professor) cadastrado pode se logar ao sistema por meio do fornecimento de email e senha corretos.

Um administrador (coordenador) cadastrado pode se logar ao sistema por meio do fornecimento de email e senha corretos.


## password_reset

**Model**

User
Admin

**View**

- /admins/passwords/new.html.erb
- /admins/passwords/edit.html.erb
- /users/passwords/new.html.erb
- /users/passwords/edit.html.erb

**Controller**

- /users/passwords_controller.rb
- /admins/passwords_controller.rb

**Explicação**

A troca de senha de usuário e admin é feito por meio de métodos herdados por controllers nativas do Devise,uma gem de autenticação de email e senha.

Um usuário (aluno e professor) cadastrado pode trocar de senha por meio do fornecimento de email válido. Ao abrir o seu email, encontrará um email de Camaar solicitando-o para trocar de senha, o que guiará para uma página em que o solicitante pode trocar de senha.

Um administrador (coordenador) cadastrado pode trocar de senha por meio do fornecimento de email válido. Ao abrir o seu email, encontrará um email de Camaar solicitando-o para trocar de senha, o que guiará para uma página em que o administrador solicitante pode trocar de senha.

## signup_user

**Model**

User
Admin

**View**

- /admins/registrations/new.html.erb
- /users/registrations/new.html.erb

**Controller**

- /users/registrations_controller.rb
- /admins/registrations_controller.rb

**Explicação**

O registro de usuário e admin é feito por meio de métodos herdados por controllers nativas do Devise,uma gem de autenticação de email e senha.

Um administrador (coordenador) pode ser cadastrado ao acessar a view de registro de administrador. Nela, fornecerá email e senha, de modo a fornecer um pré-registro ao sistema. Ao submeter o registro, será enviado um email de confirmação ao administrador/coordenador, e este só será criado se confirmar este email e seu registro respeitar as regras de integridade do banco de dados.

Um usuário (aluno ou professor) só pode ser cadastradoao se um administrador/coordenador importar os dados de email de membros da turma (formato json). Após a importação, será enviado um email individual solicitando que o usuário se registre no sistema Camaar, e este fornecerá somente a senha, de modo a concluir seu respectivo registro.

# Forms

Features que envolvem criação, submissão e envio de formulários

## create_form

**Model**

- Coordinator
- Template
- TemplateQuestion
- Form
- FormQuestion
- SubjectClass

**View**

- /admins/envio

**Controller**

- /admins_controller#envio

**Explicação**

Para criar um form, você precisa se um coordenador e acessar a opção "Envio" na sidebar para você ser redirecionado para página "dispatch"

Nessa página você pode selecionar um template de professor e/ou um template de aluno. Você pode enviar para ambos ou só para um.

Em seguida você pode selecionar as turmas do seu departamento listadas como checklists, e selecionar para quais você quer enviar um form, conforme os templates selecionados.

Por fim, você pode enviar ou cancelar a operação.

Se tudo tiver ok, a controller faz uma copia dos dados de Template para Form, e copia os dados de TemplateQuestion para FormQuestion. Isso é feito para que edits e deletes de templates não influenciem os forms que já foram enviados.

**TODO**

- Melhorar a seleção de turmas (filtros, selecionar todos, selecionar com filtro, etc)

## submit_form

**Model**

- Form
- FormQuestion
- Student/Teacher
- StudentAnswer/TeacherAnswer

**View**

- /forms/index
- /forms/edit

**Controller**

- /answers_controller#create
- /forms_controller#edit

**Explicação**

A página para responder o form é feita na rota de editar form. Dessa forma podemos obter o form e suas questões a partir dos params da url e também aproveitar dos helpers do rails.
Quando o aluno/professor preenche todos campos do form e confirma o envio, os dados são enviados para a "answers_controller" onde são criadas respostas associadas ao aluno/professor.

**TODO**

- Preservar respostas caso o usuário preencha um campo errado
- Indicar visualmente os campos preenchidos erroneamente

# IO

Features relacionadas à importação de dados para o sistema e à exportação de arquivos (xlms, gráficos, pdf, etc)

## export_results

**Model**

- Form
- FormQuestions
- StudentAnswer/TeacherAnswer

**View**

- /admins/results

**Controller**

- /admins_controller#results

**Explicação**

Para exportar os resultados, você só precisa clicar em um dos botões presentes nos vários cards de formulários na página.

O botão de gráfico exporta um arquivo png com a porcentagem de alunos/professores da turma que já responderam o form.

O botão de download exporta um arquivo csv que lista o título e todas as respostas para cada uma das questões do form enviado. Não é possível saber quem deu cada uma das respostas.

**TODO**

- Melhorar o export de gráfico

## import_data

**Model**

- Coordinator
- Student
- Teacher
- Enrollment
- SubjectClass

**View**

- /admins/import

**Controller**

- /admins_controller#import

**Explicação**

O coordenador pode selecionar entre 3 opções para import de arquivos: turmas, membros e departamentos

O import de turmas registra todas turmas no arquivo
O import de membros registra os alunos e professores, associando eles à turma de referência. Além disso, caso o usuário associado ao email passado não exista, ele envia um link para cadastro.
O import de departamentos cria os dados dos departamentos passados

**TODO**

- Melhorar a checagem do formato da estrutura dos jsons passados

**Model**

- Coordinator
- Student
- Teacher
- Enrollment
- SubjectClass

**View**

- /admins/import

**Controller**

- /admins_controller#import

**Explicação**

O coordenador pode selecionar entre 3 opções para import de arquivos: turmas, membros e departamentos

Caso um turma já exista, ele atualiza somente nome e horário (outros dados são considerados chaves)
O import de membros atualiza a referência de professor a uma turma (caso tenha mudado), adiciona novos alunos a turma existente e exclui a associação de alunos que não estão mais presentes na lista de membros do json
O import de departamentos cria ou atualiza os dados dos departamentos passados

# Templates

Features realacionadas ao CRUD de templates e questões

## create_edit_template

**Model**

- Coordinator
- Template
- TemplateQuestion

**View**

- /templates/edit
- /templates/index
- /template_questions/edit
- /template_questions/new

**Controller**

- /templates_controller
- /templates_questions_controller

**Explicação**

Para criar um template, um coordenador precisa seguir a opção "Templates" na sidebar, ir pra página de templates e precionar "Adicionar Template". Quando você adiciona um template, você cria um template marcado como "draft" na database.

Você irá ser redirecionado para página de editar template, onde você poderá adicionar questões a ele e modificar seu nome e tipo ("discente" ou "docente").

Para salvar os dados você precisa ter criado pelo menos uma questão.

**Bugs**

Por conta da relação entre as models de template e questões, seria necessário a criação de um formulário aninhado para registrar os dados em ambas models. Como isso é algo relativamente complexo e o tempo era extremamente curto, optamos por tentar refatorar a criação de templates futuramente.
Na implementação atual, embora funcional, precisamos primeiro CRIAR um template para só então criar suas perguntas. Adicionamos o atributo "draft" como uma forma de saber se ele possui ou não perguntas e se pode ser usado na criação de formulários.

## delete_template

**Model**

- Coordinator

- Template

- TemplateQuestion

**View**

- /templates/edit
- /templates/index

**Controller**

- /templates_controller

**Explicação**

Um template pode ser deletado a partir o botão de delete presente no seu card na página de "templates", ou pode ser deletado pelo botão de delete da página de edição do template.

Deletar um template também deleta as questões relacionadas a ele, mas mantém os forms criados a partir dele.

# Visualization

Features que descrevem as páginas do site com foco na visualização, e não necessariamente nas funcionalidades das páginas

## classes_page // departments_page

**Model**

- Coordinator
- Department
- SubjectClass

**View**

- subject_classes/index

**Controller**

- subject_classes_controller

**Explicação**

Lista as turmas do departamento do coordenador logado em uma tabela.

**TODO**

- Filtros

## forms_page

**Model**

- Student/Teacher
- Form
- FormQuestion
- StudentAnswer/TeacherAnswer
- Enrollment
- SubjectClass

**View**

- /forms/index

**Controller**

- forms_controller

**Explicação**

Essa página mostra os formulários respondidos ou não respondidos de um aluno/professor em cards.
Para o aluno, os forms são encontrados a partir da model intermediária Enrollment que associa um aluno a uma turma.

Assim, localizamos os forms a partir do id da turma e da role (docente ou discente) do form. Finalmente separamos os forms em respondidos ou pendentes verificando se existem respostas associadas a ele e ao aluno/professor em questão.

## results_page

**Model**

- Coordinator
- Form
- FormQuestion
- StudentAnswer/TeacherAnswer

**View**

- /admins/results

**Controller**

- /admins_controller#results

**Explicação**

Essa página lista todos os forms criados por um coordenador em vários cards.

Cada card possui um link para uma página de resumo de respostas, um botão para exportar gráfico e um botão para baixar as respostas em csv

Seguindo o link do card, você é redirecionado para uma página que resume as respostas de múltipla escolha em gráficos de pizza e lista as respostas textuais

**TODO**

- Filtros no index
- Diferenciar form respondido de não respondido no index
- Diferenciar form aluno e professor no index
- Melhorar o opção de exportar gráfico no card
- Colocar opção para exportar a página de resumo de respostas como pdf

## templates_page

**Model**

- Coordinator
- Template

**View**

- /templates/index

**Controller**

- /templates_controller

**Explicação**

Lista todos templates criado por um coordenador como cards.

Cada card possui um link para uma página de edição de template, um botão de delete e um botão de editar (redundante)

**TODO**

- Filtros
- Diferenciar templates draft de finalizado
- Diferenciar template aluno e professor
