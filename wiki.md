# Wiki da Sprint 1 - CAMAAR

## 1. Informações Gerais

### Resumo
A aplicação **CAMAAR** consiste em um sistema desenvolvido com o framework *Ruby on Rails* para fins acadêmicos. Essa aplicação facilita a gestão, coleta e análise de formulários de avaliação acerca de disciplinas ofertadas pela Universidade de Brasília (UnB), que podem ser respondidos tanto por alunos quanto por professores

### Integrantes

| Nome Completo | Matrícula |
|---------------|-----------|
| Caio Medeiros Balaniuk | 231025190 |
| Davi Henrique Vieira Lima | 231013529 |
| Lucca Schoen de Almeida | 231018900 |

## 2. Papéis da Equipe (Scrum)

**Product Owner (PO):** Davi Henrique Vieira Lima  
**Scrum Master (SM):** Lucca Schoen de Almeida

## 3. Funcionalidades Desenvolvidas (Histórias de Usuário)

As funcionalidades desenvolvidas foram estabelecidas com base nas histórias de usuário apresentadas nas issues. Desse modo, a seguir temos as funcionalidades com suas respectivas pontuações e regras de negócio:

| Issue | Funcionalidade | Descrição / Regras de Negócio (Resumo) | Responsável | Pontos |
|:---:|---|---|---|:---:|
| **098** | Importar dados do SIGAA | Deve ler CSV/JSON do SIGAA e popular o banco. Validar duplicidade. | Lucca | 5 |
| **099** | Responder formulário | Permitir que usuário logado envie respostas. | Caio | 3 |
| **100** | Cadastrar usuários do sistema | CRUD de usuários. Deve exigir email válido. | Davi | 3 |
| **101** | Gerar relatório do administrador | Compilar dados de avaliações em formato visual/exportável para o Admin. | Davi | 5 |
| **102** | Criar template de formulário | Permitir criação de perguntas para avaliações. | Caio | 8 |
| **103** | Criar formulário de avaliação | Instanciar um formulário a partir de um template para uma disciplina. | Lucca | 5 |
| **104** | Sistema de login | Autenticação via email/senha. Bloquear acesso sem login. | Davi | 5 |
| **105** | Sistema de definição de senha | Fluxo de criação ou recuperação de senha segura. | Caio | 3 |
| **108** | Atualizar base com dados do SIGAA | Sincronização de dados existentes. Não deve sobrescrever dados manuais. | Lucca | 3 |
| **109** | Visualização de forms (Responder) | Listagem de formulários pendentes disponíveis para o usuário atual. | Davi | 3 |
| **110** | Visualização de resultados | Exibição gráfica ou tabular das respostas coletadas (apenas Admin/Prof). | Caio | 5 |
| **111** | Visualização dos templates criados | Listagem de todos os templates com opções de gestão. | Davi | 2 |
| **112** | Edição e deleção de templates | Alterar perguntas de templates. A deleção não deve alterar formulários já instanciados. | Lucca | 5 |

## 4. Política de Branching

Para garantir a rastreabilidade do código e a organização durante os ciclos de desenvolvimento, estabelecemos as seguintes diretrizes técnicas para commits, nomeação de branches e fluxo de trabalho.

## 4.1. Convenções de Commits
Tanto as mensagens de commit quanto os nomes das branches compartilham os seguintes prefixos:
* `feat`: Para novas funcionalidades.

* `fix`: Para correção de bugs.

* `refactor`: Para refatoração de código

* `test`: Para criação ou alteração de testes

* `docs`: Para documentação

Os commits devem ser atômicos e descritivos, seguindo o formato:

    `{prefixo}: {mensagem com verbo na 3ª pessoa do presente}`

As branches devem ser nomeadas em **kebab-case**, sempre categorizadas pelo prefixo da tarefa:

    `{prefixo}/{nome-da-branch}`

## 4.2. Estratégia de Branching (Fluxo de Trabalho)

Adotamos um modelo híbrido focado em Sprints, garantindo que a branch principal (`main`) permaneça estável. Contendo, assim, as seguintes características:
- **`main`**: A fonte da verdade e versão estável do projeto
- **Branch da Sprint** (ex: `sprint-1`, `sprint-2`): Uma branch intermediária, criada a cada ciclo, para inserir os arquivos obrigatórios da entrega. 
- **Branches de Tarefa** (Features/Fixes): Branches individuais criadas pelos desenvolvedores para modificações específicas

Com base nisso, o ciclo de desenvolvimento é dado por:

1. **Criação**: Cada membro cria uma branch para sua tarefa específica (ex: `feat/form-creation`), partindo da branch correta (geralmente a branch da Sprint atual ou `main`, conforme o início do ciclo)

2. **Desenvolvimento e Merge**: Ao concluir a tarefa, o desenvolvedor não faz o merge direto na `main`. O código deve ser fundido na Branch da Sprint vigente

3. **Quality Assurance**: Para que o merge seja aceito na branch da Sprint, é obrigatório:
   - Abrir um Pull Request
   - Passar nos testes automáticos
   - Obter a aprovação de pelo menos 1 revisor

4. **Finalização**: Apenas ao encerrar a sprint, a "Branch da Sprint" (com todas as features acumuladas e testadas) será fundida via Pull Request na branch `main`

## 5. Pontuação (Velocity)

A equipe atribuiu pontos (Story Points) para cada história de usuário especificada nesta sprint, para o cálculo da métrica velocity.

| História de Usuário (Feature) | Pontos (Story Points) |
|-------------------------------|----------------------:|
| Importar dados do SIGAA | 5 |
| Responder formulário | 3 |
| Cadastrar usuários do sistema | 3 |
| Gerar relatório do administrador | 5 |
| Criar template de formulário | 8 |
| Criar formulário de avaliação | 5 |
| Sistema de login | 5 |
| Sistema de definição de senha | 3 |
| Atualizar base de dados com os dados do SIGAA | 3 |
| Visualização de formulários para responder | 3 |
| Visualização de resultados dos formulários | 5 |
| Visualização dos templates criados | 2 |
| Edição e deleção de templates | 5 |

**Velocity Total Planejada (Sprint 1):** 55