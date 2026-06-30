# Wiki - Sprint 1

## Escopo da Sprint

A Sprint 1 representa a etapa inicial do desenvolvimento do CAMAAR e teve como foco a **especificação** das funcionalidades do sistema, não sua implementação. Nesta fase, o grupo se dedicou ao entendimento das histórias de usuário disponibilizadas no repositório, à organização do backlog do projeto e à definição clara dos comportamentos esperados para cada feature, de modo que as próximas Sprints possam concentrar-se exclusivamente na codificação, apoiadas em critérios de aceitação bem definidos desde o início.

As funcionalidades especificadas nesta Sprint cobrem cinco grandes áreas do sistema:
 - Autenticação e gestão de credenciais** (login, cadastro, redefinição e definição de senha);
 - Gestão de formulários (criação geral, criação direcionada a discentes ou docentes, resposta de formulário e visualização de pendências),
 - Gestão de templates (criação, listagem e edição/deleção),
 - Integração com o SIGAA (importação inicial e atualização incremental de dados);
 - Administração e análise: (relatórios consolidados, visualização de resultados e gerenciamento por departamento)

Assim como foi pedido na especificação os entregáveis desta sprint foram:
- Criação de testesde aceitação das histórias de usuário usando Cucumber;
- Abertura de Pull Request (PR) no repositório principal contendo as especificações dos testes
- Geração de documento txt contendo as informações referentes ao projeto.
- Criação da Wiki em MarkDown do grupo. 

## Funcionalidades Especificadas

Nesta Sprint, foram especificadas as seguintes funcionalidades:

| ID  | Funcionalidade | Issue | Descrição | Responsável | Pontos |
|---|---|---|---|---|---:|
| F01 | Login de usuário | [#104](https://github.com/EngSwCIC/CAMAAR/issues/104) | login de usuário ao sistema | Yuri Santana Lopes | 2 |
| F02 | Cadastro de usuário | [#100](https://github.com/EngSwCIC/CAMAAR/issues/100) | cadastrar novo usuário no sistema | Luidgi Varela Carneiro | 2 |
| F03 | Redefinição de senha de usuário | [#107](https://github.com/EngSwCIC/CAMAAR/issues/107) | redefinir a senha para um usuário já criado | João Vitor das Neves Romero | 3 |
| F04 | Criação de formulário | [#103](https://github.com/EngSwCIC/CAMAAR/issues/103) | criar formulário para os alunos ou professores responderem | João Felipe Stein | 5 |
| F05 | Responder formulário criado | [#99](https://github.com/EngSwCIC/CAMAAR/issues/99) | usuário deve conseguir responder um formulário que já foi criado | Arthur Souza Chagas | 5 |
| F06 | Importar dados do SIGAA | [#98](https://github.com/EngSwCIC/CAMAAR/issues/98) | usuário deve conseguir importar dados do SIGAA para popular o banco de dados | João Vitor das Neves Romero | 5 |
| F07 | Criar template de formulário | [#102](https://github.com/EngSwCIC/CAMAAR/issues/102) | usuário deve conseguir criar templates de formulários para serem reaproveitados | João Felipe Stein | 5 |
| F08 | Gerar relatório do administrador | [#101](https://github.com/EngSwCIC/CAMAAR/issues/101) | usuário deve conseguir gerar um relatório de administrador contendo informações referentes a todos os formulários respondidos | Arthur Souza Chagas | 8 |
| F09 | Definição de senha | [#105](https://github.com/EngSwCIC/CAMAAR/issues/105) | usuário deve conseguir definir uma senha para email já criado | Yuri Santana Lopes | 3 |
| F10 | Criação de formulário para discentes e docentes | [#113](https://github.com/EngSwCIC/CAMAAR/issues/113) | usuário deve conseguir criar formulários para público alvo | Luidgi Varela Carneiro | 3 |
| F11 | Atualizar base de dados com os dados do SIGAA | [#108](https://github.com/EngSwCIC/CAMAAR/issues/108) | usuário deve conseguir atualizar a base de dados do CAMAAR com novos dados do SIGAA | Yuri Santana Lopes | 8 |
| F12 | Sistema de gerenciamento por departamento | [#106](https://github.com/EngSwCIC/CAMAAR/issues/106) | usuário deve conseguir gerenciar usuários e turmas a partir do departamento | Arthur Souza Chagas | 8 |
| F13 | Visualização de formulários para responder | [#109](https://github.com/EngSwCIC/CAMAAR/issues/109) | usuário deve conseguir visualizar quais formulários ele precisa responder | João Felipe Stein | 3 |
| F14 | Visualização de resultados de formulários | [#110](https://github.com/EngSwCIC/CAMAAR/issues/110) | usuário deve visualizar os resultados do formulário requisitado | Luidgi Varela Carneiro | 5 |
| F15 | Visualização de templates criados | [#111](https://github.com/EngSwCIC/CAMAAR/issues/111) | usuário deve visualizar a lista dos templates de formulário existentes no sistema | João Vitor das Neves Romero | 2 |
| F16 | Edição / deleção de templates | [#112](https://github.com/EngSwCIC/CAMAAR/issues/112) | usuário deve conseguir editar ou remover templates de formulário previamente criados | João Felipe Stein | 3 |




---

##  Regras de Negócio

### Funcionalidade F01 - Login de usuário

| Código | Regra de Negócio |
|---|---|
| RN01 | A autenticação só é concedida mediante email cadastrado e senha correspondente |

### Funcionalidade F02 - Cadastro de usuário

| Código | Regra de Negócio |
|---|---|
| RN05 | O email informado deve ser único no sistema |
| RN06 | A senha deve atender aos requisitos mínimos de complexidade (mínimo de 8 caracteres, contendo letras e números) |
| RN07 | Nome, email e senha são campos obrigatórios |
| RN08 | A confirmação de senha deve coincidir com a senha informada |
| RN09 | O email deve estar em formato válido |

### Funcionalidade F03 - Redefinição de senha de usuário

| Código | Regra de Negócio |
|---|---|
| RN11 | A nova senha deve atender aos requisitos mínimos de complexidade |
| RN12 | A nova senha deve ser diferente da senha atual do usuário |
| RN13 | Os dois campos de nova senha devem coincidir para que a alteração seja efetivada |

### Funcionalidade F04 - Criação de formulário

| Código | Regra de Negócio |
|---|---|
| RN14 | Apenas usuários com perfil de administrador ou professor podem criar formulários |
| RN15 | Todo formulário deve estar vinculado a uma turma e a um público-alvo (discente ou docente) |
| RN16 | O nome do formulário e o template selecionado são campos obrigatórios |
| RN17 | Não podem existir dois formulários com o mesmo nome para a mesma turma e mesmo público-alvo |
| RN18 | Não é possível criar formulário para discentes em uma turma sem discentes matriculados |

### Funcionalidade F05 - Responder formulário criado

| Código | Regra de Negócio |
|---|---|
| RN19 | O usuário só pode responder formulários direcionados ao seu público-alvo (discente/docente) |
| RN20 | O usuário só pode responder formulários da turma em que está matriculado ou vinculado |
| RN21 | Cada usuário pode responder o mesmo formulário apenas uma única vez |
| RN22 | Formulários encerrados não podem ser respondidos |
| RN23 | Todas as perguntas obrigatórias devem ser respondidas para que o formulário possa ser submetido |

### Funcionalidade F06 - Importar dados do SIGAA

| Código | Regra de Negócio |
|---|---|
| RN24 | Apenas usuários com perfil de administrador podem importar dados do SIGAA |
| RN25 | O arquivo importado deve estar em formato suportado pelo sistema |
| RN26 | O arquivo deve respeitar o tamanho máximo configurado pelo sistema |
| RN27 | Registros com campos obrigatórios ausentes não devem ser importados |
| RN28 | Em caso de falha durante a importação, nenhum registro deve ser persistido parcialmente (atomicidade) |

### Funcionalidade F07 - Criar template de formulário

| Código | Regra de Negócio |
|---|---|
| RN29 | Apenas usuários com perfil de administrador podem criar templates |
| RN30 | Todo template deve possuir um nome único no sistema |
| RN31 | Um template deve conter ao menos uma pergunta para ser considerado válido |
| RN32 | Cada pergunta deve ter um enunciado obrigatório |
| RN33 | Perguntas do tipo radio devem possuir ao menos duas opções de resposta |
| RN34 | Quando definido, o gabarito de uma pergunta deve apontar para uma das opções existentes |

### Funcionalidade F08 - Gerar relatório do administrador

| Código | Regra de Negócio |
|---|---|
| RN35 | Apenas usuários com perfil de administrador podem gerar relatórios consolidados |
| RN39 | Apenas formulários com ao menos uma resposta registrada são contabilizados no relatório |

### Funcionalidade F09 - Definição de senha

| Código | Regra de Negócio |
|---|---|
| RN40 | A definição de senha é destinada a usuários previamente cadastrados sem senha definida |
| RN41 | O link de definição de senha possui prazo de validade limitado |
| RN42 | A senha definida deve atender aos requisitos mínimos de complexidade |
| RN43 | Os dois campos de senha devem coincidir para que a definição seja efetivada |
| RN44 | Após a definição, o usuário deve ser redirecionado para a tela de login |

### Funcionalidade F10 - Criação de formulário para discentes e docentes

| Código | Regra de Negócio |
|---|---|
| RN45 | A criação de formulário deve permitir explicitamente a seleção do público-alvo: discente ou docente |
| RN46 | Formulários direcionados a discentes só são visíveis para discentes vinculados à turma |
| RN47 | Formulários direcionados a docentes só são visíveis para docentes vinculados à turma |
| RN48 | O administrador pode criar formulários distintos para discentes e docentes em uma mesma turma |

### Funcionalidade F11 - Atualizar base de dados com os dados do SIGAA

| Código | Regra de Negócio |
|---|---|
| RN49 | Apenas usuários com perfil de administrador podem atualizar dados via SIGAA |
| RN50 | A operação de atualização identifica e atualiza apenas registros já existentes no banco |
| RN51 | Registros novos identificados no arquivo devem ser sinalizados ao administrador para decisão |
| RN52 | Registros do banco ausentes no arquivo devem ser sinalizados ao administrador para decisão |
| RN53 | Em caso de falha, o banco deve ser mantido no estado anterior à operação |
| RN54 | Atualizações em massa devem requerer confirmação prévia do administrador |

### Funcionalidade F12 - Sistema de gerenciamento por departamento

| Código | Regra de Negócio |
|---|---|
| RN55 | Cada usuário e cada turma devem estar vinculados a um departamento |
| RN56 | Apenas usuários com perfil de administrador podem gerenciar a estrutura de departamentos |
| RN57 | O nome do departamento deve ser único no sistema |
| RN58 | Não é possível remover um departamento que possua usuários ou turmas vinculados |
| RN59 | Coordenadores de departamento têm acesso de gerenciamento restrito ao seu próprio departamento |

### Funcionalidade F13 - Visualização de formulários para responder

| Código | Regra de Negócio |
|---|---|
| RN60 | O usuário deve visualizar apenas formulários direcionados ao seu público-alvo |
| RN61 | O usuário deve visualizar apenas formulários das turmas em que está vinculado |
| RN62 | Formulários já respondidos pelo usuário devem ser sinalizados visualmente |
| RN63 | Formulários encerrados não devem aparecer na lista de pendências |
| RN64 | A listagem deve ordenar os formulários por prazo de resposta, do mais próximo ao mais distante |

### Funcionalidade F14 - Visualização de resultados de formulários

| Código | Regra de Negócio |
|---|---|
| RN65 | Apenas usuários com perfil de administrador podem visualizar resultados de formulários |
| RN66 | Formulários com número de respostas abaixo do mínimo configurado não exibem distribuição individual (anonimato) |
| RN67 | Os resultados devem apresentar dados agregados e estatísticas (média, total de respostas) |
| RN68 | Formulários ainda sem respostas devem exibir mensagem informativa em vez de gráficos vazios |
| RN69 | A visualização deve permitir filtros por turma e por público-alvo |

### Funcionalidade F15 - Visualização de templates criados

| Código | Regra de Negócio |
|---|---|
| RN70 | Apenas usuários com perfil de administrador podem visualizar a lista de templates |
| RN71 | A listagem deve exibir nome, número de perguntas e data de criação de cada template |
| RN72 | Templates em uso por formulários ativos devem ser sinalizados na listagem |
| RN73 | A listagem deve permitir busca por nome do template |

### Funcionalidade F16 - Edição / deleção de templates

| Código | Regra de Negócio |
|---|---|
| RN74 | Apenas usuários com perfil de administrador podem editar ou deletar templates |
| RN75 | Templates em uso por formulários existentes não podem ser deletados |
| RN76 | A edição de um template não deve afetar formulários já criados a partir dele |
| RN78 | A deleção de um template requer confirmação explícita do administrador |

---

## Pontuação das Histórias e Velocity

A pontuação foi atribuída considerando a complexidade, o esforço e a incerteza de cada história de usuário.

| História | Descrição resumida | Responsável | Pontos |
|---|---|---|---:|
| HU01 | Como usuário cadastrado, quero fazer login no sistema, para acessar as funcionalidades disponíveis ao meu perfil | Yuri Santana Lopes | 2 |
| HU02 | Como visitante, quero me cadastrar no sistema, para utilizar as funcionalidades do CAMAAR | Luidgi Varela Carneiro | 2 |
| HU03 | Como usuário, quero redefinir minha senha, para recuperar o acesso à minha conta | João Vitor das Neves Romero | 3 |
| HU04 | Como administrador, quero criar formulários, para coletar feedback de discentes e docentes | João Felipe Stein | 5 |
| HU05 | Como discente ou docente, quero responder os formulários disponíveis, para contribuir com a avaliação acadêmica | Arthur Souza Chagas | 5 |
| HU06 | Como administrador, quero importar dados do SIGAA, para popular rapidamente o banco de dados do CAMAAR | João Vitor das Neves Romero | 5 |
| HU07 | Como administrador, quero criar templates de formulário, para reaproveitar estruturas em diferentes formulários | João Felipe Stein | 5 |
| HU08 | Como administrador, quero gerar relatórios consolidados, para acompanhar o desempenho geral das turmas | Arthur Souza Chagas | 8 |
| HU09 | Como usuário com cadastro pré-existente, quero definir minha senha, para acessar o sistema pela primeira vez | Yuri Santana Lopes | 3 |
| HU10 | Como administrador, quero criar formulários direcionados a um público específico, para coletar feedback adequado ao perfil dos respondentes | Luidgi Varela Carneiro | 3 |
| HU11 | Como administrador, quero atualizar a base de dados com informações do SIGAA, para manter o CAMAAR sincronizado com a fonte oficial | Yuri Santana Lopes | 8 |
| HU12 | Como administrador, quero gerenciar usuários e turmas por departamento, para organizar o sistema conforme a estrutura institucional | Arthur Souza Chagas | 8 |
| HU13 | Como discente ou docente, quero visualizar os formulários que preciso responder, para não esquecer pendências | João Felipe Stein | 3 |
| HU14 | Como administrador, quero visualizar os resultados de um formulário específico, para analisar o feedback recebido | Luidgi Varela Carneiro | 5 |
| HU15 | Como administrador, quero visualizar a lista de templates existentes, para reutilizá-los na criação de formulários | João Vitor das Neves Romero | 2 |
| HU16 | Como administrador, quero editar ou deletar templates, para manter a base de templates organizada e atualizada | João Felipe Stein | 3 |

**Velocity estimada da Sprint:** 70 pontos

---
