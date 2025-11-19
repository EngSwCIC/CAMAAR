# Wiki CAMAAR - Plataforma de Avaliação de Cursos

---

## Informações do Projeto

| Item | Descrição |
|------|-----------|
| **Nome do Projeto** | CAMAAR - Plataforma de Avaliação de Cursos |
| **Disciplina** | Engenharia de Software |
| **Período** | 2025.2 |
| **Integrantes do Grupo** | Bernardo Gomes Rodrigues - 231034190 <br> Isaac Silva - 231025216 <br> Filipe Abadia Marcelino - 190087161 <br> Maria Carolina Burgum Abreu Jorge - 231013547 |

---

## Papéis Scrum

| Papel | Responsável | Matrícula |
|-------|-------------|-----------|
| **Scrum Master** | Bernardo Gomes Rodrigues | 231034190 |
| **Product Owner** | Maria Carolina Burgum Abreu Jorge | 231013547 |

---

## Escopo do Projeto

### Descrição Geral

O CAMAAR é uma **plataforma web para avaliação de cursos e disciplinas** integrada com o SIGAA (Sistema Integrado de Gestão de Atividades Acadêmicas) por meio de arquivos JSON. O sistema permite que administradores (coordenadores de cursos) criem formulários de avaliação que são respondidos por alunos e professores, gerando relatórios sobre o desempenho das disciplinas e infraestrutura.

### Objetivos Principais

- Automatizar o processo de coleta de feedback sobre disciplinas
- Integrar dados do SIGAA para alimentar a plataforma
- Permitir análise de dados através de exportação em CSV
- Fornecer controle de acesso baseado em departamento
- Facilitar a gestão de templates reutilizáveis de formulários

### Stakeholders

- **Coordenadores de Curso** (Administradores): Criam e gerenciam formulários
- **Professores**: Respondem questionários sobre infraestrutura e ementa
- **Alunos**: Avaliam disciplinas e professores
- **Sistema SIGAA**: Fornecedor de dados de turmas, disciplinas e participantes

---

## Funcionalidades e Regras de Negócio

### 1. Autenticação de Usuários (5 pontos)

**Funcionalidades:**
- Login com email ou matrícula + senha
- Definir senha após convite de cadastro
- Email de boas vindas informando a senha (se aplicável)
- Recuperar acesso através de email (redefinir senha)

**Regras de Negócio:**
- Senhas devem ter no mínimo 4 caracteres
- Senhas devem conter pelo menos: 1 letra maiúscula, 1 letra minúscula, 1 número e 1 caractere especial
- Email de boas-vindas enviado automaticamente após criação de usuário
- Usuário deve alterar senha temporária no primeiro acesso

**Responsável:** [Nome do desenvolvedor]

---

### 2. Importação de Dados do SIGAA (8 pontos)

**Funcionalidades:**
- Importar turmas, disciplinas e participantes do SIGAA
- Atualizar dados existentes com informações atualizadas
- Manter histórico de importações
- Marcar turmas como inativas quando descontinuadas

**Regras de Negócio:**
- Importação deve ser realizada apenas por administradores
- Registros duplicados são ignorados (validação por ID único do SIGAA)
- Ao importar novos usuários, criar contas com senha temporária
- Dados importados não devem sobrescrever informações customizadas no sistema
- Participantes removidos do SIGAA devem ter acesso desativado
- Atualização de mudanças de turmas de alunos/professores

**Responsável:** [Nome do desenvolvedor]

---

### 3. Gerenciamento de Templates de Formulários (5 pontos)

**Funcionalidades:**
- Criar templates com múltiplos tipos de questões
- Visualizar templates criados
- Editar templates
- Deletar templates

**Regras de Negócio:**
- Template deve ter no mínimo 1 questão
- Nome do template deve ser único por administrador
- Apenas o criador do template pode editá-lo (ou outro admin do mesmo departamento)
- Tipos de questões suportados: Múltipla escolha, Texto aberto, Verdadeiro/Falso
- Edições em template afetam apenas novos formulários criados, não retroativamente
- Administrador só pode gerenciar templates do seu departamento

**Responsável:** [Nome do desenvolvedor]

---

### 4. Criação de Formulários (8 pontos)

**Funcionalidades:**
- Criar formulário baseado em template
- Selecionar turmas para aplicar o formulário
- Escolher tipo de avaliador (docentes ou discentes)
- Visualizar formulários criados

**Regras de Negócio:**
- Formulário herda todas as questões do template no momento da criação
- Deve selecionar no mínimo 1 turma
- Deve escolher tipo de avaliador (obrigatório)
- Apenas turmas do departamento do administrador podem ser selecionadas
- Mesmo formulário não pode ser respondido 2 vezes pelo mesmo participante

**Responsável:** [Nome do desenvolvedor]

---

### 5. Resposta de Questionários (5 pontos)

**Funcionalidades:**
- Visualizar formulários não respondidos
- Responder questionário
- Submeter respostas
- Filtrar respostas de turmas

**Regras de Negócio:**
- Participante visualiza apenas formulários de turmas onde está matriculado
- Todos os campos obrigatórios devem ser preenchidos antes de enviar
- Participante pode editar respostas enquanto formulário não foi enviado
- Uma vez enviado, não pode ser alterado
- Resposta não pode ser submetida duas vezes pelo mesmo participante
- Sistema valida tipo de resposta conforme tipo de questão

**Responsável:** [Nome do desenvolvedor]

---

### 6. Exportação de Resultados (5 pontos)

**Funcionalidades:**
- Exportar respostas em formato CSV
- Filtrar por formulário
- Download do arquivo

**Regras de Negócio:**
- Apenas administrador pode exportar resultados
- Arquivo CSV deve conter: ID da resposta, Participante, Data de resposta, Respostas individuais
- Formato CSV deve ser compatível com planilhas
- Caracteres especiais devem estar codificados corretamente (UTF-8)
- Arquivo só pode ser gerado se houver respostas
- Apenas respostas de formulários do departamento do admin são exportadas
- Nomes de participantes anonimizados por padrão (apenas matrícula mostrada)
- Arquivo gerado com timestamp: `formulario_[id]_[data_hora].csv`

**Responsável:** [Nome do desenvolvedor]

---

### 7. Controle de Acesso por Departamento (5 pontos)

**Funcionalidades:**
- Visualizar apenas turmas do departamento
- Criar formulários apenas para turmas do departamento
- Gerenciar templates apenas do departamento
- Controle de permissão em operações

**Regras de Negócio:**
- Administrador só vê/gerencia turmas do seu departamento
- Administrador não pode criar formulário para turma de outro departamento
- Erro 403 (Acesso Negado) deve ser retornado para tentativas não autorizadas
- Super Admin pode gerenciar múltiplos departamentos (se aplicável)
- Departamento é definido no perfil do usuário durante importação do SIGAA

**Responsável:** [Nome do desenvolvedor]

---

### 8. Diferenciação de Avaliadores (3 pontos)

**Funcionalidades:**
- Escolher tipo de avaliador (docentes ou discentes)
- Exibir formulário apenas para o tipo correto

**Regras de Negócio:**
- Ao criar formulário, obrigatório selecionar tipo: "Docentes" ou "Discentes"
- Aluno só vê formulários criados para "Discentes"
- Professor só vê formulários criados para "Docentes"
- Sistema valida tipo de usuário ao tentar acessar formulário
- Formulário para docente é enviado apenas para professores das turmas
- Formulário para discente é enviado apenas para alunos das turmas
- Mesmo formulário com dois tipos diferentes pode coexistir para mesma turma

**Responsável:** [Nome do desenvolvedor]

---

### 9. Gestão de Usuários e Participantes (3 pontos)

**Funcionalidades:**
- Cadastro automático de participantes na importação
- Desativação de participantes inativos
- Visualização de histórico de usuários

**Regras de Negócio:**
- Usuários são criados automaticamente durante importação do SIGAA
- Usuário inativo não pode fazer login
- Quando participante é removido do SIGAA, status muda para inativo
- Email de boas-vindas é enviado automaticamente (se aplicável)
- Senha temporária é gerada e enviada no email de boas vindas
- Histórico de mudanças de status é mantido

**Responsável:** [Nome do desenvolvedor]

---

## Atribuição de Histórias de Usuário

| # | História de Usuário | Funcionalidade | Pontos | Responsável |
|---|---------------------|-----------------|--------|-------------|
| 1 | Importar dados do SIGAA | Importação de Dados | 8 | [Nome] |
| 2 | Responder questionário sobre turma | Resposta de Questionários | 5 | [Nome] |
| 3 | Cadastrar participantes ao importar | Gestão de Usuários | 3 | [Nome] |
| 4 | Baixar resultados em CSV | Exportação de Resultados | 5 | [Nome] |
| 5 | Criar template de formulário | Gerenciamento de Templates | 5 | [Nome] |
| 6 | Criar formulário baseado em template | Criação de Formulários | 8 | [Nome] |
| 7 | Acessar sistema com credenciais | Autenticação | 3 | [Nome] |
| 8 | Definir senha após cadastro | Autenticação | 2 | [Nome] |
| 9 | Gerenciar turmas do departamento | Controle de Acesso | 5 | [Nome] |
| 10 | Redefinir senha | Autenticação | 3 | [Nome] |
| 11 | Atualizar base de dados existente | Importação de Dados | 5 | [Nome] |
| 12 | Visualizar formulários não respondidos | Resposta de Questionários | 3 | [Nome] |
| 13 | Visualizar formulários criados | Criação de Formulários | 3 | [Nome] |
| 14 | Visualizar templates criados | Gerenciamento de Templates | 2 | [Nome] |
| 15 | Editar e deletar template | Gerenciamento de Templates | 3 | [Nome] |
| 16 | Escolher tipo de avaliador | Diferenciação de Avaliadores | 3 | [Nome] |

**Total de Pontos: 62 pontos**

---

## Histórias de Usuário Detalhadas com Pontuação

### HU-01: Importar dados do SIGAA (8 pontos)

```
Como Administrador
Quero importar dados de turmas, matérias e participantes do SIGAA
A fim de alimentar a base de dados do sistema

Critérios de Aceitação:
- Sistema importa com sucesso turmas, disciplinas e participantes do SIGAA
- Dados duplicados são ignorados e registrados em relatório
- Novos usuários recebem email de boas-vindas
- Histórico de importação é salvo com timestamp
- Erro de conexão é tratado graciosamente
- Máximo 1 importação simultânea
```

**Pontos:** 8 | **Responsável:** [Nome]

---

### HU-02: Responder questionário sobre turma (5 pontos)

```
Como Participante de uma turma
Quero responder o questionário sobre a turma em que estou matriculado
A fim de submeter minha avaliação da turma

Critérios de Aceitação:
- Visualiza questionário da turma
- Preenche questões obrigatórias
- Submete respostas finais
- Não pode responder 2 vezes o mesmo formulário
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-03: Cadastrar participantes ao importar (3 pontos)

```
Como Administrador
Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos
A fim de que eles acessem o sistema CAMAAR

Critérios de Aceitação:
- Novos usuários são criados automaticamente
- Cada usuário recebe email de boas-vindas
- Senha temporária é gerada
- Usuário deve alterar senha no primeiro acesso
- Usuários já existentes são associados às novas turmas
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-04: Baixar resultados em CSV (5 pontos)

```
Como Administrador
Quero baixar um arquivo CSV contendo os resultados de um formulário
A fim de avaliar o desempenho das turmas

Critérios de Aceitação:
- Arquivo CSV é gerado com estrutura correta
- Colunas: ID, Participante, Data, Respostas
- Caracteres especiais codificados (UTF-8)
- Filtro por turma específica
- Anonimização de nomes (apenas matrícula)
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-05: Criar template de formulário (5 pontos)

```
Como Administrador
Quero criar um template de formulário contendo as questões
A fim de gerar formulários de avaliações reutilizáveis

Critérios de Aceitação:
- Template com nome único
- Mínimo 1 questão obrigatória
- Suporta múltiplos tipos: múltipla escolha, texto, V/F
- Apenas criador pode editar
- Edições não afetam formulários já criados
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-06: Criar formulário baseado em template (8 pontos)

```
Como Administrador
Quero criar um formulário baseado em um template para turmas escolhidas
A fim de avaliar o desempenho das turmas no semestre atual

Critérios de Aceitação:
- Seleciona template
- Escolhe múltiplas turmas (mínimo 1)
- Escolhe tipo de avaliador (docentes/discentes)
- Formulário herda questões do template
- Notificação enviada aos participantes
```

**Pontos:** 8 | **Responsável:** [Nome]

---

### HU-07: Acessar sistema com credenciais (3 pontos)

```
Como Usuário do sistema
Quero acessar o sistema utilizando email e senha
A fim de responder formulários ou gerenciar o sistema

Critérios de Aceitação:
- Login com email funciona
- Validação de credenciais
- Redirecionamento para painel
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-08: Definir senha após cadastro (2 pontos)

```
Como Usuário
Quero definir uma senha para o meu usuário a partir do email de cadastro
A fim de acessar o sistema

Critérios de Aceitação:
- Senha deve cumprir critérios de segurança
- Senhas devem conferir
- Redirecionamento para login após sucesso
```

**Pontos:** 2 | **Responsável:** [Nome]

---

### HU-09: Gerenciar turmas do departamento (5 pontos)

```
Como Administrador
Quero gerenciar somente as turmas do departamento o qual eu pertenço
A fim de avaliar o desempenho das turmas no semestre atual

Critérios de Aceitação:
- Visualiza apenas turmas do departamento
- Criar formulário apenas com turmas do departamento
- Erro 403 para tentativas de acesso não autorizado
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-10: Redefinir senha (3 pontos)

```
Como Usuário
Quero redefinir uma senha a partir do email recebido
A fim de recuperar meu acesso ao sistema

Critérios de Aceitação:
- Validação de senha
- Email de confirmação enviado
- Redirecionamento para login
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-11: Atualizar base de dados existente (5 pontos)

```
Como Administrador
Quero atualizar a base de dados com dados atuais do SIGAA
A fim de corrigir a base de dados do sistema

Critérios de Aceitação:
- Sincroniza dados existentes
- Adiciona novos dados
- Atualiza mudanças de turmas
- Mantém histórico de atualizações
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-12: Visualizar formulários não respondidos (3 pontos)

```
Como Participante de uma turma
Quero visualizar os formulários não respondidos das turmas em que estou matriculado
A fim de poder escolher qual irei responder

Critérios de Aceitação:
- Lista apenas formulários não respondidos
- Mostra turma, disciplina, datas
- Formulários respondidos não aparecem
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-13: Visualizar formulários criados (3 pontos)

```
Como Administrador
Quero visualizar os formulários criados
A fim de poder gerar um relatório a partir das respostas

Critérios de Aceitação:
- Lista todos os formulários
- Mostra nome, template, turmas, status, data
- Quantidade de respostas exibida
- Acesso apenas a formulários do departamento
- Opção de visualizar detalhes
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-14: Visualizar templates criados (2 pontos)

```
Como Administrador
Quero visualizar os templates criados
A fim de poder editar e/ou deletar um template que eu criei

Critérios de Aceitação:
- Lista todos os templates
- Mostra nome, quantidade de questões, data
- Acesso aos detalhes
- Opções de editar/deletar
```

**Pontos:** 2 | **Responsável:** [Nome]

---

### HU-15: Editar e deletar template (3 pontos)

```
Como Administrador
Quero editar e/ou deletar um template que eu criei sem afetar formulários já criados
A fim de organizar os templates existentes

Critérios de Aceitação:
- Confirmação de exclusão
- Apenas criador pode editar e excluir
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-16: Escolher tipo de avaliador (3 pontos)

```
Como Administrador
Quero escolher criar um formulário para os docentes ou os discentes de uma turma
A fim de avaliar o desempenho de uma matéria

Critérios de Aceitação:
- Opção obrigatória: Docentes ou Discentes
- Professores veem apenas formulários para Docentes
- Alunos veem apenas formulários para Discentes
- Múltiplos formulários podem coexistir para mesma turma
```

**Pontos:** 3 | **Responsável:** [Nome]

---

## Política de Branching

### Estratégia Git Flow

```
- main: Produção (releases e hotfixes)
- develop: Desenvolvimento principal
- feature/HU-XX-descricao: Novas funcionalidades
- bugfix/HU-XX-descricao: Correções de bugs
- hotfix/issue-descricao: Correções urgentes em produção
```

### Fluxo de Trabalho

1. **Iniciar Nova Funcionalidade:**
   - Criação de branch para a funcionalidade
   - Garantir que a nova branch está atualizada com as alterações da main

2. **Trabalhar na Funcionalidade:**
   - Commits descritivos em português
   - Formato: `HU-01: Descrição da alteração`
   - Exemplo: `HU-01: Implementar validação de duplicatas`

3. **Pull Request para Develop:**
   - Descrever as alterações
   - Referenciar a HU
   - Mínimo 1 aprovação antes de merge
   - Rodar testes antes de merge

### Convenção de Commits

```
<tipo>(<escopo>): <descrição>

<corpo>
```

**Tipos:**
- `feat`: Nova funcionalidade (HU)
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Tarefas de build/dependências

**Exemplo:**
```
feat(autenticacao): Implementar login com email e matrícula
```

---

## Métricas e Velocidade

### Cálculo de Velocity

**Sprint Atual:**
- Total de Pontos: **62 pontos**
- Histórias por Sprint: [A definir conforme organização]

**Fórmula:**
```
Velocity = Pontos Concluídos / Número de Sprints

Exemplo (após 3 sprints):
Sprint 1: 21 pontos
Sprint 2: 18 pontos
Sprint 3: 20 pontos
Velocity Média = (21+18+20)/3 = 19.67 pontos/sprint
```

### Capacidade de Planning

```
Baseado na velocity média, para próxima sprint:
- Pontos a planejar ≈ Velocity média
- Buffer (20% do total) para imprevistos
- Ajustar conforme necessário
```

---

## Próximos Passos

- [X] Preencher nomes e matrículas dos integrantes
- [ ] Definir duração de cada sprint
- [ ] Criar backlog com priorização
- [X] Configurar repositório Git
- [X] Configurar ambiente de desenvolvimento
- [X] Criar estrutura inicial do Rails
- [X] Iniciar Sprint 1
