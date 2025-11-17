# Sprint 1 - Sistema CAMAAR

## 📋 Informações do Grupo

**Grupo:** Grupo 3  
**Projeto:** CAMAAR - Sistema para Avaliação de Atividades Acadêmicas Remotas  
**Escopo:** Avaliação de Atividades Acadêmicas

### Integrantes

| Nome | Matrícula | Email | GitHub |
|------|-----------|-------|--------|
| Mateus Santos da Silva | 190018011 | 190018011@aluno.unb.br | @avlis-mat |
| Cauet Gabriel Dias Braga | 211060577 | 211060577@aluno.unb.br | @cauet-code |
| Henrique Carvalho Wolski | 231013627 | 231013627@aluno.unb.br | @Henrique-wolski |

---

## 👥 Papéis da Sprint

- **Scrum Master:** Mateus
- **Product Owner:** Henrique

---

## 🎯 Funcionalidades Desenvolvidas


### Issue #103: Criar formulário de avaliação

**Responsável:** Mateus
**Pontos:** 8  
**Status:** Cenários BDD especificados

**História de Usuário:**
> **Como** Administrador do sistema
> **Eu quero** criar um formulário baseado em um template para as turmas que eu escolher
> **Para que** eu possa avaliar o desempenho das turmas no semestre atual

**Regras de Negócio:**
- **RN01:** Apenas usuários com perfil de Administrador podem criar formulários
- **RN02:** Template é obrigatório e deve existir no sistema
- **RN03:** Pelo menos uma turma deve ser selecionada
- **RN04:** Período de disponibilidade é obrigatório (semestre)
- **RN05:** Professor é obrigatório
- **RN06:** Formulário herda todas as questões do template selecionado
- **RN07:** Título do formulário é definido como "[Avaliação] - [Nome_da_matéria] - [Semestre]"
- **RN08:** Respostas devem ser anônimas
- **RN09:** Usuário deve visualizar confirmação de resposta
- **RN10:** Usuário não deve virualizar resposta

#### Dependências

**Pré-requisitos:**
- Issue #102: Criar Template de Formulário (deve ser implementado primeiro)
- Sistema de gerenciamento de turmas
- Sistema de autenticação de usuários

**Integração com:**
- Templates de formulário (usa templates criados)
- Cadastro de turmas (seleciona turmas existentes)
- Sistema de permissões (valida acesso de administrador)

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Criar formulário para uma turma com sucesso

**Cenários Tristes (Validações e Erros):**
1. Tentar criar formulário sem selecionar template

**Total de cenários:** 2
---

#### Campos do Formulário

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Template | Seleção | Sim | Template base para o formulário |
| Turmas | Múltipla seleção | Sim | Uma ou mais turmas para avaliação |
| Semestre | Seleção | Sim | Semestre considerado |
| Professor | Seleção | Sim | Professo da Turma |
| Título | Texto | Sim | Título personalizado (padrão: nome do template) |

#### Arquivo de Especificação

📄 `features/criar_formulario_avaliacao.feature`

---

### Issue #102: Criar Template de Formulário

**Responsável:** Mateus 
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário (Padrão Connextra)

> **Como** Administrador do sistema  
> **Eu quero** criar templates de formulários contendo questões personalizadas  
> **Para que** eu possa gerar formulários de avaliação reutilizáveis para avaliar o desempenho das turmas

#### Regras de Negócio

- **RN01:** Apenas usuários com perfil de Administrador podem criar templates
- **RN02:** Nome do template é obrigatório e deve ter entre 3 e 100 caracteres
- **RN03:** Nome do template deve ser único no sistema
- **RN04:** Template deve conter pelo menos 1 questão
- **RN05:** Cada questão deve ter um enunciado obrigatório
- **RN06:** Questões de múltipla escolha devem ter no mínimo 2 alternativas

#### Tipos de Questões Suportadas

| Tipo | Descrição |
|------|-----------|
| Dissertativa | Resposta em texto livre |
| Múltipla Escolha | Seleção de uma alternativa entre várias opções |

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Criar template de formulário com sucesso

**Cenários Tristes (Validações e Erros):**
1. Tentar criar template sem nome

**Total de cenários:** 2

#### Arquivo de Especificação

📄 `features/criar_template_formulario.feature`

---

### Issue #101: Gerar Relatório do Administrador

**Responsável:** Mateus
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador do sistema  
> **Eu quero** baixar um arquivo CSV contendo os resultados de um formulário  
> **Para que** eu possa avaliar o desempenho das turmas

#### Regras de Negócio

- **RN01:** Apenas administradores podem gerar relatórios
- **RN02:** Relatório deve ser gerado em formato CSV
- **RN03:** CSV deve conter cabeçalhos identificando as colunas
- **RN04:** Dados devem seguir padrão CSV (vírgula como separador, aspas para texto com vírgula)
- **RN05:** Nome do arquivo deve identificar o formulário e período
- **RN06:** Possível filtrar respostas por Nome da matéria
- **RN07:** Formulários não devem expor identificação dos respondentes
- **RN08:** Relatório sem respostas deve gerar arquivo apenas com cabeçalhos

#### Estrutura do CSV
```csv
ID,Data,Turma,Questão,Resposta,Tipo
1,2025-03-10 14:30,Cálculo 1,Como você avalia?,Ótimo,Dissertativa
2,2025-03-10 15:45,Cálculo 1,Satisfeito?,Sim,Múltipla Escolha
3,2025-03-11 09:20,Cálculo 1,Nota de 1 a 10,8,Múltipla Escolha
```

#### Cenários BDD Implementados

**Cenários Felizes:**
- Baixar relatório em CSV com sucesso

**Cenários Tristes:**
- Tentar baixar relatório de formulário sem respostas

**Total:** 2 cenários

#### Dependências

- Issue #03: Criar Formulário de avaliação (deve existir formulário)
- Issue #99: Responder Formulário (devem existir respostas)

#### Arquivo

📄 `features/gerar_relatorio_do_dministrador_101.feature`

---

### Issue #100: Cadastrar Usuários do Sistema

**Responsável:** Mateus
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador do sistema  
> **Eu quero** cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
> **Para que** eles possam acessar o sistema CAMAAR

**Observação Importante:** O cadastro do usuário só é efetivado após a definição da senha pelo próprio usuário.

#### Regras de Negócio

- **RN01:** Apenas administradores podem enviar convites de cadastro
- **RN02:** Usuário só existe na base após importação (Issue #98)
- **RN03:** Cadastro é um processo em duas etapas: importação + definição de senha
- **RN04:** Link de convite expira em 48 horas
- **RN05:** Após definir senha, usuário está apto a fazer login
- **RN06:** Administrador pode reenviar convite (invalida link anterior)
- **RN07:** Sistema mantém histórico de convites enviados

#### Status de Usuário

| Status | Descrição |
|--------|-----------|
| Pendente | Importado, aguardando envio de convite |
| Convite Enviado | Convite enviado, aguardando definição de senha |
| Ativo | Senha definida, pode fazer login |
| Link Expirado | Convite expirou, precisa reenviar |


#### Cenários BDD Implementados

**Cenários Felizes:**
- Enviar convite de cadastro para usuário importado

**Cenários Tristes:**
- Tentar definir senha com formato inválido

**Depende de:**
- Issue #17: Importar Dados do SIGAA (usuários devem ser importados primeiro)

**Usado por:**
- Sistema de autenticação (login)

#### Arquivo

📄 `features/cadastrar_usuarios_do_sistema.feature`

---

### Issue #99: Responder Formulário

**Responsável:** Mateus
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Participante de uma turma  
> **Eu quero** responder o questionário sobre a turma em que estou matriculado  
> **Para que** eu possa submeter minha avaliação da turma

#### Regras de Negócio

- **RN01:** Apenas alunos autenticados podem responder formulários
- **RN02:** Aluno só pode responder formulários das turmas em que está matriculado
- **RN03:** Todas as questões obrigatórias devem ser respondidas
- **RN04:** Formulário só pode ser respondido uma vez por aluno
- **RN05:** Sistema deve pedir confirmação antes de enviar
- **RN06:** Após envio, não é possível editar respostas
- **RN07:** Após envio, é possível visualizar confirmação de resposta
- **RN08:** Após envio, não é possível visualizar respostas

#### Dependências

**Pré-requisitos:**
- Issue #103: Criar formulário de avaliação (deve ser implementado primeiro)
- Sistema de gerenciamento de turmas
- Sistema de autenticação de usuários

**Integração com:**
- Templates de formulário (usa templates criados)
- Cadastro de turmas (seleciona turmas existentes)
- Sistema de permissões (valida acesso de administrador)

#### Cenários BDD Implementados

**Cenários Felizes:**
- Responder formulário com sucesso

**Cenários Tristes:**
- Tentar responder sem preencher todas as questões obrigatórias

**Total:** 2 cenários

#### Arquivo

📄 `features/responder_formulario.feature`

---

### Issue #98: Importar Dados do SIGAA

**Responsável:** Mateus
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador do sistema  
> **Eu quero** importar dados de turmas, matérias e participantes do SIGAA  
> **Para que** eu possa alimentar a base de dados do sistema  

#### Regras de Negócio

- **RN01:** Apenas administradores podem importar dados
- **RN02:** Arquivos devem estar em formato JSON válido
- **RN03:** Sistema deve verificar se dados já existem antes de importar
- **RN04:** Dados duplicados devem ser ignorados, não sobrescritos
- **RN05:** Campos obrigatórios devem ser validados
- **RN07:** Sistema deve gerar relatório de importação
- **RN08:** Tamanho máximo de arquivo: 5MB
- **RN09:** Ordem de importação: Matérias → Turmas → Participantes
- **RN10:** Erros não devem interromper toda a importação (processar o que for válido)

#### Estrutura dos JSONs

**turmas.json:**
```json
{
  "turmas": [
    {
      "codigo": "CIC0097",
      "nome": "BANCOS DE DADOS",
      "turma_codigo": "TA",
      "semestre": "2021.2",
      "horario": "35T45"
    }
  ]
}
```


**participantes.json:**
```json
{
  "participantes": [
    {
      "matricula": "123456",
      "nome": "Maria Santos",
      "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
      "email": "maria@aluno.unb.br",
      "formacao": "graduando",
      "ocupacao": "discente",
      "usuario": "123456",
      "usuario_has_turma": "CIC0097"
    }
  ]
}
```
| Entidade | Campos Obrigatórios |
|----------|---------------------|
| Turma | codigo, nome, turma_codigo, semestre, horario |
| Participante | matricula, nome, curso, email, formacao, ocupacao, usuario, usuario_has_turma |

#### Cenários BDD Implementados

**Cenários Felizes:**
- Importar turmas com sucesso


**Cenários Tristes:**
- Tentar importar arquivo JSON inválido

#### Arquivo

📄 `features/importar_dados_do_sigaa_98.feature`

---

### Issue #109: Visualização de formulários para responder

**Responsável:** Cauet Gabriel Dias Braga
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Participante de uma turma  
> **Eu quero** visualizar os formulários não respondidos das turmas em que estou matriculado  
> **Para que** eu possa escolher qual irei responder

#### Regras de Negócio

- **RN01:** Apenas alunos autenticados podem visualizar formulários
- **RN02:** Aluno só pode visualizar formulários das turmas em que está matriculado
- **RN03:** Formulários já respondidos não devem aparecer na lista de pendentes
- **RN04:** Formulários com prazo expirado devem ser marcados como "Prazo expirado"
- **RN05:** Sistema deve separar formulários pendentes e respondidos em abas
- **RN06:** Sistema deve permitir filtrar formulários por turma
- **RN07:** Sistema deve mostrar data limite para responder cada formulário

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Visualizar formulários pendentes para responder
2. Não visualizar formulários já respondidos
3. Visualizar abas de formulários pendentes e respondidos
4. Filtrar formulários por turma

**Cenários Tristes (Validações e Erros):**
1. Visualizar mensagem quando não há formulários pendentes
2. Tentar responder formulário com prazo expirado
3. Não visualizar formulários de turmas que não estou matriculado

**Total de cenários:** 7

#### Arquivo de Especificação

📄 `features/visualizacao_formularios_responder_109.feature`

---

### Issue #110: Visualização de resultados dos formulários

**Responsável:** Cauet Gabriel Dias Braga
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador  
> **Eu quero** visualizar os formulários criados  
> **Para que** eu possa gerar um relatório a partir das respostas

#### Regras de Negócio

- **RN01:** Apenas administradores podem visualizar resultados
- **RN02:** Sistema deve mostrar lista de todos os formulários criados
- **RN03:** Cada formulário deve exibir número de respostas recebidas
- **RN04:** Sistema deve permitir visualizar detalhes de cada resposta
- **RN05:** Sistema deve permitir gerar relatório em CSV
- **RN06:** Sistema deve permitir filtrar respostas por data
- **RN07:** Sistema deve exibir estatísticas das respostas (média, moda, etc)

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Visualizar lista de formulários com respostas
2. Visualizar detalhes das respostas de um formulário
3. Gerar relatório em CSV com sucesso
4. Filtrar respostas por data

**Cenários Tristes (Validações e Erros):**
1. Visualizar formulário sem respostas
2. Tentar acessar relatório de formulário inexistente

**Total de cenários:** 6

#### Arquivo de Especificação

📄 `features/visualizacao_resultados_formularios_110.feature`

---

### Issue #111: Visualização dos templates criados

**Responsável:** Cauet Gabriel Dias Braga
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador  
> **Eu quero** visualizar os templates criados  
> **Para que** eu possa editar e/ou deletar um template que eu criei

#### Regras de Negócio

- **RN01:** Apenas administradores podem visualizar templates
- **RN02:** Sistema deve exibir lista de todos os templates criados
- **RN03:** Cada template deve mostrar nome, quantidade de questões e data de criação
- **RN04:** Sistema deve permitir visualizar detalhes completos de um template
- **RN05:** Sistema deve permitir pesquisar templates por nome
- **RN06:** Sistema deve exibir opções de "Editar" e "Deletar" para cada template

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Visualizar lista de templates com sucesso
2. Visualizar detalhes de um template
3. Pesquisar templates por nome

**Cenários Tristes (Validações e Erros):**
1. Visualizar templates quando não há nenhum criado
2. Tentar visualizar template deletado

**Total de cenários:** 5

#### Arquivo de Especificação

📄 `features/visualizacao_templates_criados_111.feature`

---

### Issue #112: Edição e deleção de templates

**Responsável:** Cauet
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador  
> **Eu quero** editar e/ou deletar um template que eu criei sem afetar os formulários já criados  
> **Para que** eu possa organizar os templates existentes

#### Regras de Negócio

- **RN01:** Apenas administradores podem editar/deletar templates
- **RN02:** Apenas o criador do template pode editá-lo/deletá-lo
- **RN03:** Edição de template não deve afetar formulários já criados
- **RN04:** Deleção de template não deve afetar formulários já criados
- **RN05:** Sistema deve solicitar confirmação antes de deletar
- **RN06:** Sistema deve permitir adicionar questões ao template durante edição
- **RN07:** Sistema deve permitir alterar nome do template

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Editar template existente com sucesso
2. Deletar template com sucesso

**Cenários Tristes (Validações e Erros):**
1. Tentar deletar template sem confirmação
2. Editar template removendo questões obrigatórias

**Total de cenários:** 4

#### Arquivo de Especificação

📄 `features/edicao_delecao_templates_112.feature`

---

### Issue #113: Criação de formulário para docentes ou dicentes

**Responsável:** Cauet Gabriel Dias Braga
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador  
> **Eu quero** escolher criar um formulário para os docentes ou os dicentes de uma turma  
> **Para que** eu possa avaliar o desempenho de uma matéria

#### Regras de Negócio

- **RN01:** Apenas administradores podem criar formulários
- **RN02:** Tipo de formulário (Docentes/Dicentes) é obrigatório
- **RN03:** Turma é obrigatória
- **RN04:** Template é obrigatório
- **RN05:** Formulário para docentes deve estar disponível apenas para professores da turma
- **RN06:** Formulário para dicentes deve estar disponível apenas para alunos da turma
- **RN07:** Formulário deve conter todas as questões do template selecionado

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Criar formulário para docentes com sucesso
2. Criar formulário para dicentes com sucesso

**Cenários Tristes (Validações e Erros):**
1. Tentar criar formulário sem selecionar tipo
2. Tentar criar formulário sem selecionar turma
3. Tentar criar formulário sem selecionar template

**Total de cenários:** 5

#### Arquivo de Especificação

📄 `features/criacao_formulario_docentes_dicentes_113.feature`

---

### Issue #248: Nova issue de exemplo

**Responsável:** Cauet Gabriel Dias Braga
**Pontos:** 3  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Usuário  
> **Eu quero** criar uma nova issue  
> **Para que** ela apareça no meu Projects do Github

#### Regras de Negócio

- **RN01:** Título da issue é obrigatório
- **RN02:** Descrição da issue é obrigatória
- **RN03:** Issue criada deve aparecer na lista de issues do projeto
- **RN04:** Issue deve estar visível no Projects do Github

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Criar issue com sucesso

**Cenários Tristes (Validações e Erros):**
1. Tentar criar issue sem título
2. Tentar criar issue sem descrição

**Total de cenários:** 3

#### Arquivo de Especificação

📄 `features/nova_issue_de_exemplo_248.feature`

---

### Issue #108: Atualizar base de dados com os dados do SIGAA

**Responsável:** Henrique
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador do sistema  
> **Eu quero** atualizar a base de dados já existente com os dados atuais do SIGAA  
> **Para que** eu possa corrigir a base de dados do sistema

#### Regras de Negócio

- **RN01:** Apenas administradores podem atualizar a base de dados
- **RN02:** Sistema deve conectar ao SIGAA para obter dados atualizados
- **RN03:** Dados existentes devem ser atualizados com informações mais recentes
- **RN04:** Novos registros devem ser adicionados se existirem no SIGAA
- **RN05:** Sistema deve gerar relatório de atualização mostrando alterações
- **RN06:** Atualização deve solicitar confirmação antes de executar
- **RN07:** Dados inválidos não devem interromper toda a atualização
- **RN08:** Sistema deve tratar erros de conexão com SIGAA
- **RN09:** Link de atualização deve expirar após 24 horas (se aplicável)

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Atualizar base de dados com sucesso
2. Atualizar base de dados sem alterações

**Cenários Tristes (Validações e Erros):**
1. Tentar atualizar quando SIGAA está indisponível
2. Tentar atualizar sem confirmação
3. Atualização parcial devido a dados inválidos

**Total de cenários:** 5

#### Dependências

**Pré-requisitos:**
- Issue #98: Importar Dados do SIGAA (deve existir base de dados inicial)
- Sistema de autenticação de administradores

**Integração com:**
- Sistema de importação do SIGAA (usa mesma estrutura de dados)
- Base de dados do sistema (atualiza registros existentes)

#### Arquivo de Especificação

📄 `features/atualizar_bd_SIGAA.feature`

---

### Issue #107: Redefinição de senha (Bonus)

**Responsável:** Henrique
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Usuário do sistema  
> **Eu quero** redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha  
> **Para que** eu possa recuperar o meu acesso ao sistema

#### Regras de Negócio

- **RN01:** Usuário deve solicitar redefinição através do link "Esqueci minha senha"
- **RN02:** Sistema deve validar se o email existe no sistema
- **RN03:** Link de redefinição deve ser enviado por email
- **RN04:** Link de redefinição expira em 24 horas
- **RN05:** Token de redefinição deve ser único e seguro
- **RN06:** Nova senha deve seguir critérios de segurança (mínimo 6 caracteres)
- **RN07:** Confirmação de senha deve coincidir com a nova senha
- **RN08:** Sistema deve permitir redefinição usando email ou matrícula
- **RN09:** Após redefinição bem-sucedida, usuário deve ser redirecionado para login

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Solicitar redefinição de senha com email válido
2. Redefinir senha com token válido
3. Redefinir senha usando matrícula

**Cenários Tristes (Validações e Erros):**
1. Tentar solicitar redefinição com email inexistente
2. Tentar redefinir senha com token inválido
3. Tentar redefinir senha com senhas não coincidentes
4. Tentar redefinir senha com senha fraca
5. Tentar usar link de redefinição expirado

**Total de cenários:** 8

#### Dependências

**Pré-requisitos:**
- Sistema de cadastro de usuários
- Sistema de envio de emails
- Sistema de autenticação

**Integração com:**
- Sistema de login (após redefinição, usuário pode fazer login)
- Sistema de cadastro (usa mesma estrutura de usuários)

#### Arquivo de Especificação

📄 `features/redefinir_senha.feature`

---

### Issue #106: Sistema de gerenciamento por departamento (Bonus)

**Responsável:** Henrique
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Administrador do sistema  
> **Eu quero** gerenciar somente as turmas do departamento o qual eu pertenço  
> **Para que** eu possa avaliar o desempenho das turmas no semestre atual

#### Regras de Negócio

- **RN01:** Administrador deve estar associado a um departamento
- **RN02:** Administrador só pode visualizar turmas do seu departamento
- **RN03:** Administrador só pode criar formulários para turmas do seu departamento
- **RN04:** Administrador só pode visualizar resultados de turmas do seu departamento
- **RN05:** Sistema deve filtrar automaticamente por departamento do administrador
- **RN06:** Tentativas de acesso a turmas de outros departamentos devem ser bloqueadas
- **RN07:** Sistema deve exibir filtro indicando o departamento atual
- **RN08:** Administrador pode filtrar turmas por semestre dentro do seu departamento

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Visualizar apenas turmas do meu departamento
2. Criar formulário apenas para turmas do meu departamento
3. Visualizar resultados apenas de turmas do meu departamento
4. Filtrar turmas por semestre dentro do meu departamento

**Cenários Tristes (Validações e Erros):**
1. Tentar acessar turma de outro departamento
2. Visualizar mensagem quando não há turmas no meu departamento
3. Tentar criar formulário para turma de outro departamento

**Total de cenários:** 7

#### Dependências

**Pré-requisitos:**
- Sistema de autenticação de administradores
- Sistema de associação de administradores a departamentos
- Sistema de gerenciamento de turmas

**Integração com:**
- Sistema de criação de formulários (filtra turmas por departamento)
- Sistema de visualização de resultados (filtra por departamento)
- Sistema de importação do SIGAA (associa departamentos)

#### Arquivo de Especificação

📄 `features/sistema_gerenciamento_por_departamento.feature`

---

### Issue #105: Sistema de definição de senha

**Responsável:** Henrique
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Usuário do sistema  
> **Eu quero** definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro  
> **Para que** eu possa acessar o sistema

#### Regras de Negócio

- **RN01:** Usuário deve ser importado do SIGAA antes de receber convite
- **RN02:** Link de definição de senha deve ser enviado por email após importação
- **RN03:** Link de definição de senha expira em 48 horas
- **RN04:** Token de definição deve ser único e seguro
- **RN05:** Senha deve seguir critérios de segurança (mínimo 6 caracteres)
- **RN06:** Confirmação de senha deve coincidir com a senha definida
- **RN07:** Após definir senha, usuário está apto a fazer login
- **RN08:** Usuário que já possui senha não pode usar link de definição
- **RN09:** Todos os campos são obrigatórios

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Definir senha com sucesso através do link do email
2. Definir senha usando matrícula no link

**Cenários Tristes (Validações e Erros):**
1. Tentar definir senha com link inválido
2. Tentar definir senha com senhas não coincidentes
3. Tentar definir senha com senha muito curta
4. Tentar definir senha com campos vazios
5. Tentar usar link de definição de senha expirado
6. Tentar definir senha para usuário que já possui senha

**Total de cenários:** 8

#### Dependências

**Pré-requisitos:**
- Issue #98: Importar Dados do SIGAA (usuários devem ser importados primeiro)
- Issue #100: Cadastrar Usuários do Sistema (convite deve ser enviado)
- Sistema de envio de emails

**Usado por:**
- Sistema de login (usuário precisa definir senha antes de fazer login)

#### Arquivo de Especificação

📄 `features/sistema_definir_senha.feature`

---

### Issue #104: Sistema de Login

**Responsável:** Henrique
**Pontos:** 5  
**Status:** Cenários BDD especificados

#### História de Usuário

> **Como** Usuário do sistema  
> **Eu quero** acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada  
> **Para que** eu possa responder formulários ou gerenciar o sistema

**Observação:** Quando o Usuário logado for um admin, deve-se mostrar a opção de gerenciamento no menu lateral.

#### Regras de Negócio

- **RN01:** Usuário deve ter senha definida para fazer login
- **RN02:** Sistema deve aceitar email ou matrícula como identificador
- **RN03:** Senha deve ser validada corretamente
- **RN04:** Tentativas de login inválidas devem mostrar mensagem de erro genérica
- **RN05:** Após login bem-sucedido, usuário deve ser redirecionado para página inicial
- **RN06:** Administradores devem ver opção "Gerenciamento" no menu lateral
- **RN07:** Usuários comuns não devem ver opção "Gerenciamento" no menu lateral
- **RN08:** Todos os campos são obrigatórios
- **RN09:** Sistema deve manter sessão do usuário após login

#### Cenários BDD Implementados

**Cenários Felizes (Caminhos de Sucesso):**
1. Fazer login com email e senha corretos
2. Fazer login com matrícula e senha corretos
3. Administrador visualiza opção de gerenciamento no menu
4. Usuário comum não visualiza opção de gerenciamento

**Cenários Tristes (Validações e Erros):**
1. Tentar fazer login com email inexistente
2. Tentar fazer login com senha incorreta
3. Tentar fazer login com matrícula inexistente
4. Tentar fazer login com campos vazios
5. Tentar fazer login com usuário que ainda não definiu senha

**Total de cenários:** 9

#### Dependências

**Pré-requisitos:**
- Issue #105: Sistema de definição de senha (usuário deve ter senha definida)
- Sistema de autenticação
- Sistema de sessões

**Integração com:**
- Sistema de gerenciamento (mostra opção para administradores)
- Sistema de formulários (usuário precisa estar autenticado)
- Sistema de permissões (define acesso baseado em perfil)

#### Arquivo de Especificação

📄 `features/sistema_login.feature`

---

## 🔄 Política de Branching

O grupo adota a seguinte estratégia de branches:
```
main (branch protegida - código do repositório original)
  └── sprint-1 (branch da sprint - usada para Pull Request)
      ├── feature/criar-template-formulario
      ├── feature/[outra-funcionalidade]
      └── feature/[outra-funcionalidade]
```

### Regras de Branching

1. A branch `main` é protegida e recebe apenas Pull Requests aprovados
2. Para cada sprint, criamos uma branch `sprint-N` 
3. Cada desenvolvedor trabalha em sua feature branch individual
4. Features são nomeadas seguindo o padrão: `feature/nome-da-funcionalidade`
5. Após aprovação do PR, a branch `sprint-N` não recebe mais commits

### Convenção de Commits
```
feat: Adiciona cenários BDD para criar template de formulário - Issue #13
test: Adiciona cenário de validação de nome duplicado - Issue #13
docs: Atualiza Wiki com informações da Sprint 1
fix: Corrige enunciado do cenário de múltipla escolha - Issue #13
```

**Padrão:**
- `feat:` Nova funcionalidade ou cenário
- `test:` Adição ou modificação de testes
- `docs:` Documentação
- `fix:` Correção de erros
- Sempre referenciar a issue (#13, #14, etc.)

---

## 📈 Velocity da Sprint

**Pontos Planejados:** 86  
**Pontos Concluídos:** 86  
**Velocity da Sprint:** 86 pontos

### Distribuição de Pontos por Funcionalidade

| Issue | Funcionalidade | Responsável | Pontos | Status |
|-------|----------------|-------------|--------|--------|
| #103 | Criar formulário de avaliação | Mateus | 8 | ✅ Especificado |
| #102 | Criar Template de Formulário | Mateus | 5 | ✅ Especificado |
| #101 | Gerar reltório do administrador | Mateus | 5 | ✅ Especificado |
| #100 | Cadastrar usuários do sistema | Mateus | 5 | ✅ Especificado |
| #99 | Responder formulário | Mateus | 5 | ✅ Especificado |
| #98 | Importar dados do SIGAA | Mateus | 5 | ✅ Especificado |
| #109 | Visualização de formulários para responder | Cauet | 5 | ✅ Especificado |
| #110 | Visualização de resultados dos formulários | Cauet | 5 | ✅ Especificado |
| #111 | Visualização dos templates criados | Cauet | 5 | ✅ Especificado |
| #112 | Edição e deleção de templates | Cauet | 5 | ✅ Especificado |
| #113 | Criação de formulário para docentes ou dicentes | Cauet | 5 | ✅ Especificado |
| #248 | Nova issue de exemplo | Cauet | 3 | ✅ Especificado |
| #108 | Atualizar base de dados com os dados do SIGAA | Henrique | 5 | ✅ Especificado |
| #107 | Redefinição de senha (Bonus) | Henrique | 5 | ✅ Especificado |
| #106 | Sistema de gerenciamento por departamento (Bonus) | Henrique | 5 | ✅ Especificado |
| #105 | Sistema de definição de senha | Henrique | 5 | ✅ Especificado |
| #104 | Sistema de Login | Henrique | 5 | ✅ Especificado |
| **TOTAL** | | | **86** | **100%** |

---