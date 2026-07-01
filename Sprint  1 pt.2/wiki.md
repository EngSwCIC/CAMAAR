# Wiki - Sprint 1

## Integrantes

| Nome | Matrícula |
|------|-----------|
| Ana Luísa Reis Nascente | 211045688 |
| Gabriel de Sousa | 211056000 |
| Maria Luiza Rodrigues de Sousa | 221007223 |
| Arthur Henrique Aprigio dos Santos | 232000481 |

**Projeto:** CAMAAR - Sistema para avaliação de atividades acadêmicas remotas do CIC

**Escopo:** Desenvolvimento das funcionalidades de autenticação, cadastro de usuários, gerenciamento por departamento, definição e redefinição de senha, criação e visualização de templates de formulário e visualização de respostas e resultados de avaliações.

---

## Papéis

- **Scrum Master:** Ana Luísa Reis Nascente
- **Product Owner:** Maria Luiza Rodrigues de Sousa

---

## Funcionalidades e Responsáveis

| Issue | Funcionalidade | Responsável | Pontos |
|-------|----------------|-------------|--------|
| #104 | Sistema de Login | Ana Luísa Reis Nascente | 3 |
| #100 | Cadastrar usuários do sistema | Ana Luísa Reis Nascente | 3 |
| #107 | Redefinição de senha | Ana Luísa Reis Nascente | 2 |
| #106 | Sistema de gerenciamento por departamento | Ana Luísa Reis Nascente | 3 |
| #105 | Sistema de definição de senha | Arthur Henrique Aprigio dos Santos | 2 |
| #98  | Importar dados do SIGAA | Arthur Henrique Aprigio dos Santos | 3 |
| #108 | Atualizar base de dados com os dados do SIGAA | Arthur Henrique Aprigio dos Santos | 3 |
| #101 | Gerar relatório do administrador | Arthur Henrique Aprigio dos Santos | 3 |
| #102 | Criar template de formulário | Maria Luiza Rodrigues de Sousa | 5 |
| #103 | Criar formulário de avaliação | Maria Luiza Rodrigues de Sousa | 5 |
| #111 | Visualização dos templates criados | Maria Luiza Rodrigues de Sousa | 3 |
| #112 | Edição e deleção de templates | Maria Luiza Rodrigues de Sousa | 3 |
| #110 | Visualização de resultados dos formulários | Gabriel de Sousa | 3 |
| #99  | Responder formulário | Gabriel de Sousa | 3 |
| #109 | Visualização de formulários para responder | Gabriel de Sousa | 3 |
| #113 | Criação de formulário para docentes ou discentes | Gabriel de Sousa | 5 |

**Velocity total da Sprint 1:** 51 pontos

---

## Regras de Negócio

### Issue #104 - Sistema de Login
- O usuário pode se autenticar com e-mail ou matrícula
- Usuários administradores visualizam a opção de "Gerenciamento" no menu lateral
- Credenciais inválidas exibem mensagem de erro e mantêm o usuário na página de login

### Issue #100 - Cadastrar usuários do sistema
- Apenas administradores podem cadastrar usuários
- O cadastro é feito a partir da importação de dados do SIGAA em formato JSON
- Arquivos com formato inválido são rejeitados com mensagem de erro

### Issue #107 - Redefinição de senha
- A redefinição é feita via link enviado por e-mail após solicitação do usuário
- Links expirados ou inválidos bloqueiam o acesso e apresentam opção de novo link
- Após redefinição bem-sucedida, o usuário é redirecionado para a tela de login

### Issue #106 - Sistema de gerenciamento por departamento
- Administradores gerenciam apenas turmas do próprio departamento
- Acesso a turmas de outros departamentos é bloqueado pelo sistema

### Issue #105 - Sistema de definição de senha
- A senha é definida a partir de um link enviado por e-mail
- As senhas digitadas nos campos "Nova Senha" e "Confirmar Senha" devem ser idênticas
- A senha é armazenada de forma criptografada
- Após definição bem-sucedida, o usuário é redirecionado para a tela de login

### Issue #98 - Importar dados do SIGAA
- Apenas administradores podem importar dados
- A importação utiliza arquivos JSON com dados de turmas, disciplinas e participantes
- Dados inválidos ou duplicados são tratados com mensagem de erro

### Issue #108 - Atualizar base de dados com os dados do SIGAA
- A atualização sincroniza os dados existentes com as informações mais recentes do SIGAA
- Registros desatualizados são sobrescritos
- O sistema notifica o administrador ao fim da atualização

### Issue #101 - Gerar relatório do administrador
- Apenas administradores podem gerar relatórios
- O relatório é exportado em formato CSV com os resultados dos formulários
- Relatórios só podem ser gerados para avaliações encerradas

### Issue #102 - Criar template de formulário
- Apenas administradores podem criar templates
- Um template deve ter título e pelo menos uma questão associada
- Templates sem questões não podem ser salvos

### Issue #103 - Criar formulário de avaliação
- Apenas administradores podem criar formulários
- O formulário deve ser baseado em um template existente
- O administrador seleciona as turmas que receberão o formulário

### Issue #111 - Visualização dos templates criados
- Apenas administradores visualizam a lista de templates
- Templates são exibidos com título e data de criação
- Templates sem formulários associados são identificados visualmente

### Issue #112 - Edição e deleção de templates
- Apenas administradores podem editar ou deletar templates
- Templates associados a formulários ativos não podem ser deletados
- Alterações em templates não afetam formulários já enviados

### Issue #110 - Visualização de resultados dos formulários
- Discentes acessam a lista de avaliações das turmas em que estão matriculados
- Avaliações encerradas exibem os resultados consolidados
- Discentes podem revisar suas próprias respostas submetidas
- Avaliações ainda abertas não revelam resultados prematuramente

### Issue #99 - Responder formulário
- Apenas participantes de turmas visualizam os formulários disponíveis
- Cada participante pode responder um formulário apenas uma vez
- O sistema confirma o envio com mensagem de sucesso

### Issue #109 - Visualização de formulários para responder
- Apenas participantes de turmas visualizam formulários pendentes
- São exibidos somente formulários ainda não respondidos
- Quando não há formulários pendentes, o sistema exibe mensagem de estado vazio

### Issue #113 - Criação de formulário para docentes ou discentes
- Apenas administradores podem criar formulários
- O formulário pode ser destinado a docentes ou discentes de uma turma
- O administrador define o período de resposta do formulário

---

## Política de Branching

Uma branch por issue, seguindo o padrão:

```
issue-<número>-<descrição-curta>
```

Exemplos: `issue-104-login`, `issue-105-definicao-senha`

Apenas 1 pull request por grupo é enviado ao repositório principal, a partir da branch `sprint-1`.
