## CAMAAR - Sistema para avaliação de atividades remotas
- ### Roberto Ribeiro Corrêa Neto - 242009936
- ### Lucas Teles Leiro - 211066131
- ### Davi Brasileiro Gomes - 241020741
# Especificações da *Sprint* 1:
**Product Owner**: Lucas Teles
**Scrum Master**: Davi Brasileiro
## Features desenvolvidas:
### Templates:
- **Visualizar template**: Nessa feature, o usuário (admin) deve ser capaz de visualizar os templates para formulários criados, quando acessar a página correspondente.\
**Responsável**: Davi Brasileiro&ensp;**Story Points**: 1
- **Editar Template**: Nessa feature, o usuário (admin) deve ser capaz de editar os templates por ele criados, podendo alterar informações próprias do template (nome, tipo...), bem como da composição de questões.\
**Responsável**: Roberto Ribeiro&ensp;**Story Points**: 5
- **Deletar Template**: Nessa feature, o usuário (admin) deve ser capaz de deletar os templates para formulários criados, quando clicar no template e entçao no botão correspondente.\
**Responsável**: Roberto RIbeiro&ensp;**Story Points**: 3
- **Buscar template**: Nessa feature, o usuário deve ser capaz de realizar a busca por templates existentes utilizando uma barra de pesquisa, filtrando os resultados na listagem.\
**Responsável**: Lucas Teles Leiro&ensp;**Story Points**: 3
### Senha:
- **Criar senha**: Nessa feature, o usuário deve ser capaz de criar uma senha logando com o email, quando acessar a plataforma pela primeira vez.\
**Responsável**: Davi Brasileiro&ensp;**Story Points**: 5
- **Redefinir senha por e-mail**: Nessa feature, o usuário deve ser capaz de requisitar a mudança de senha por link de e-mail, e a partir deste, fazer a mudança da senha.\
**Responsável**: Roberto Ribeiro&ensp;**Story Points**: 10
### Resultados:
- **Visualizar resultados**: Nessa feature, o usuário (admin) deve ser capaz de visualizar o resultado para as avaliações criadas, quando acessá-las da página correspondente.\
**Responsável**: Davi Brasileiro&ensp;**Story Points**: 3
### Formulário (avaliação):
- **Criar formulário**: Nessa feature, o usuário (admin) deve ser capaz de criar avaliações a partir de templates existentes, quando acessar a opção para tal.\
**Responsável**: Roberto Ribeiro&ensp;**Story Points**: 5
- **Ver formulário (preenchido)**: Nessa feature, o usuário (admin) deve ser capaz de visualizar as avaliações criadas, quando acessar a página correspondente.\
**Responsável**: Roberto Ribeiro&ensp;**Story Points**: 1
- **Ver formulário (não preenchido)**: Nessa feature, o usuário deve ser capaz de ver as avaliações que ainda não respondeu quando acessar a página associada.\
**Responsável**: Roberto Ribeiro&ensp;**Story Points**: 3
- **Responder formulário**: Nessa feature, o usuário (discente) deve ser capaz de preencher as questões de múltipla escolha e discursivas de um formulário disponível e enviar as respostas para concluir sua avaliação.\
**Responsável**: Lucas Teles Leiro&ensp;**Story Points**: 5
### Login / Cadastro:
- **Realizar Login**: Nessa feature, o usuário (admin / user) deve ser capaz de acessar a plataforma quando logar com e-mail e senha válidos.\
**Responsável**: Davi Brasileiro&ensp;**Story Points**: 1
- **Cadastrar usuários do sistema**: Nessa feature, o usuário (admin) deve ser capaz de cadastrar novos usuários (docentes ou discentes) informando nome, matrícula, e-mail e perfil de acesso.\
**Responsável**: Lucas Teles Leiro&ensp;**Story Points**: 5
### Dados / requisições externas:
- **Atualizar base de dados**: Nessa feature, o usuário (admin) deve ser capaz de atualizar os dados de turmas e alunos com base no banco de dados do SIGAA.\
**Responsável**: Roberto Ribeiro&ensp;**Story Points**: 10
- **Gerenciar turmas do departamento**: Nessa feature, o usuário (admin) deve ser capaz de gerenciar e de visualizar os dados das turmas que leciona quando associar as informações na página associada.\
**Responsável**: Roberto Ribeiro&ensp;**Story Points**: 7
## Estratégia de *branching*:
Inicialmente, criar uma *branch* central para consolidação das tarefas da *sprint* 1. Após isso, foi feito uma *branch* por feature implementada, sendo gradualmente feito o *merge* na branch original, agindo como centro do repositório. Com isso, evitamos conflitos na implementação das *features* por parte de cada integrante, garantindo a coesão do resultado no *merge* para a visão consolidada dos resultados da *sprint*. Após fazer todos os "merges", escolhemos deletar as branchs das features e deixar apenas a branch "feature-sprint-1" para deixar mais limpo e organizado.
