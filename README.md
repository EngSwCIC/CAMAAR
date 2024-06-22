# CAMAAR
## Grupo 7:
João Pedro Carvalho de Oliveira Rodrigues - 221017032 
Alisson Vieira Neves - 221002067
João Marcos Melo Monteiro - 130143031
Lucas da Costa Rodrigues - 221017079

# SPRINT 1

### Scrum Master: Lucas da Costa
### Product Owner: João Pedro

# Funcionalidades:

### Importação da base de dados por meio de um arquivo JSON
### Envio de email aos alunos para solicitar o cadastro da senha
### Tela de login para os alunos e professores
### Criação de templates de questionários para os professores
### Envio dos questionário para os alunos de acordo com as suas turmas
### Respostar dos alunos aos questionários
### Visualização e download dos questionarios pelos professores
### disponibilização sequencial das ferramentas na tela de gerenciamento

*detalhamento das funcionalidades nas historias de usuário.

## Política de branching:
### branch por funcionalidade


## Uso:
adm deve ser definido no cmd
ex: User.create(nome:"adm1",password:"teste1",password_confirmation:"teste1",adm:"true",email:"teste1@gmail.com")

para acessar o usuário, ir na página "http://localhost:3000/users/sign_in"
inicialmente nao devem haver alunos cadastrados.

ao logar como adm, é enviado para a pagina de gerenciamento, onde é possível importar a base de dados e enviar email aos alunos.
para evitar spam e emails acidentais, as duas funcionalidades foram separadas e as informações dos alunos estao em CAMAARAPP/class_member_teste com informações dos membros do grupo

após importar os dados dos alunos, a senha pode ser definida em "http://localhost:3000/users/sign_up/*ID*"
onde ID é substituido pelo id correspondente ao aluno

ao logar é redirecionado para "http://localhost:3000/user_home"

os testes com cucumber estão falhando pois o webdriver não possui nenhuma versão compativel com o chrome mais recente

