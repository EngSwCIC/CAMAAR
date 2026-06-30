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


# Especificações da *Sprint* 2:
**Product Owner**: Roberto Neto
**Scrum Master**: Lucas Teles

## Objetivos:
### Implementar os passos RSpec para definição dos steps de teste:
Aqui foram utilizados conceitos como **mocks, seams e factories** para aproveitar das funções da controladora na manipulação de entidades e recursos para os testes. Assim, tomou-se proveito de métodos como *find_or_create_by(:id)* para mockagem de dados, bem como métodos como *expect(content)* e *allow()* para tratar de comportamentos esperados de entidades envolvidas nas operações dos testes.

### Implementar a arquitetura MVC no Rails seguindo as entidades do MER proposto, com métodos da controladora e as views correspondentes:
- **Modelos**: Definição dos *schemas* das entidades considerando as hierarquias, relacionamentos e dependências.
- **Controladoras**: Implementação das funções CRUD para as entidades, observando a modularidade e consistência.
- **Views**: Uso do HTML + CSS + comportamento responsivo do rails por meio de funções como <%=if =%> e <%=yield =%> para maior personalização.
- **Rotas**: Uso do mecanismo padrão do rails para contrução automática de rotas e paths, com auxílio do **Devise** para autenticação e login facilitados.

## Features desenvolvidas:

### Responsável: Lucas Teles Leiro
- **Sistema de gerenciamento por departamento (#16)**: Implementação da regra de negócio que filtra a listagem de turmas para que os administradores visualizem apenas aquelas vinculadas ao seu respectivo departamento.
- **Redefinição de senha (#15)**: Implementação do fluxo para o usuário requisitar e efetuar a mudança de senha no sistema.
- **Cadastrar usuários do sistema (#3)**: Criação da interface e lógica para que administradores cadastrem novos usuários (docentes ou discentes) informando dados e perfil de acesso.
- **Buscar template (#1)**: Funcionalidade que permite ao usuário realizar buscas por templates existentes utilizando uma barra de pesquisa.
- **Responder formulário (#2)**: Funcionalidade para o discente preencher as questões de múltipla escolha e discursivas de um formulário e enviar as respostas.
- **Tratamento de Exceções e Fluxos Alternativos (Happy/Sad Paths)**: Implementação e correção das lógicas de sucesso (Happy Path) e de falha/exceção (Sad Path) nos controladores e serviços refatorados, assegurando respostas HTTP corretas (como os redirecionamentos apropriados em vez de falsos positivos `204 No Content`) e a correta exibição de alertas para o usuário.

### Responsável: Davi Brasileiro Gomes
- **Login de usuários (#9)**: Implementação do fluxo de sign-in com uso das rotas do Devise.
- **Relatório do administrador (#6)**: Implementação da opção de baixar um .csv contendo o relatório das respostas de formulários acessíveis pelo administrador do sistema.
- **Criar formulário (#7)**: Funcionalidade para criar um novo formulário a partir de um template já existente, para turmas dentro do contexto do administrador.
- **Visualizar formulário para responder (#8)**: Condição do usuário, que acessa a página de formulários para acessar aqueles que ainda vão ser respondidos, podendo selecioná-los.
- **Importar dados do SIGAA (#4)**: Capacidade de importar novos usuários a partir de arquivos .csv
- **Visualização de templates criados**: Visualizar os templates disponíveis

### Responsável: Roberto Ribeiro Corrêa Neto
- **Criar senha (#5)**: Implementação do fluxo para o usuário criar uma senha ao acessar a plataforma pela primeira vez logando com o e-mail.
- **Criar template de formulário (#10)**: Criação de templates de formulários pelo administrador, definindo nome, tipo e a composição de questões.
- **Edição e deleção de templates (#11)**: Edição dos templates criados (informações próprias e composição de questões) e remoção de templates a partir da página do template.
- **Criação de formulário para docentes ou discentes (#12)**: Criação de formulários direcionados a docentes ou discentes a partir de templates existentes.
- **Visualização de resultados dos formulários (#13)**: Visualização do resultado das avaliações criadas a partir da página correspondente (view `formularios/resultados`).
- **Atualizar base de dados com os dados do SIGAA (#14)**: Atualização dos dados de turmas e alunos com base no banco do SIGAA, incluindo o serviço `app/services/sigaa_importer.rb`.

## Estratégia de *branching*:
Para a Sprint 2, consolidamos as implementações na branch `sprint-2`. Os merges foram realizados e testados localmente, garantindo a integridade do sistema e a resolução de conflitos (incluindo chaves do Rails). [cite_start]Todos os testes RSpec [cite: 7] [cite_start]foram validados com 100% de sucesso antes da abertura do Pull Request[cite: 16].

# Especificações da *Sprint* 3:
**Product Owner**: Davi Brasileiro
**Scrum Master**: Roberto Neto

## Objetivos:
### Refatorar o código para aceitação nos testes Cucumber / RSpec:
Nessa etapa, dividimos as pastas de features BDD desenvolvidas no Capybara para refatorarmos o código e fazermos todos os testes passarem, como na estratégia do TDD (Red - Green - Refactor), evitando ao máximo alterar as features já definidas, limitando-nos a reduzir a redundância de _steps_ definidos para os testes, bem como a maior reusabilidade e desacoplamento de testes para maior confiabilidade.

### Reduzir os Code Smells e outros indícios de código mau-otimizado:
Rodamos gemas como o **Rubycritic** e **SimpleCov** para avaliar a complexidade de métodos, partes ineficientes do código e até mesmo a cobertura das funções do código por parte dos testes desenvolvidos, a fom de garantir que o código da aplicação fosse o mais robusto possível, com o mínimo de complexidade.

### Produzir a documentação da aplicação:
Nesse passo, nos valemos da gema **RDoc** para gerar páginas HTML interativas que cobrissem a documentação dos principais componentes do código, especialmente Models e Controllers, garantindo a melhor compreensão dos métodos e estruturas utilizadas para o funcionamento da aplicação, segundo as boas práticas especificadas no uso da gema, como formatação e seleção de itens documentados para melhor visualização.

## Features Desenvolvidas:

### Responsável: Lucas Teles Leiro
- **Refatoração com Padrão Service Object**: Extração da lógica de leitura e processamento de arquivos (JSON/CSV) do `UsersController` para as classes de serviço `ParticipantImporterService` e `SigaaImporter`, garantindo o princípio de responsabilidade única (SRP) e contribuindo para a redução da complexidade das controladoras no RubyCritic.
- **Implementação e Blindagem do `SigaaImporter`**: Adequação do algoritmo do importador para processar estruturas JSON aninhadas (docentes e discentes). Implementação de regras de fallback determinístico para e-mails nulos e proteção contra colisões de matrícula (`ActiveRecord::RecordInvalid`), garantindo a idempotência da funcionalidade.
- **Estabilização de Rotas e Controladores**: Correção do mapeamento de rotas e padronização da nomenclatura do `TurmasController` (resolvendo erros de `MissingController`). Implementação do método `sigaa_import` no `UsersController` para garantir o fluxo correto de requisições via upload de arquivos.
- **Resolução de Falhas na Suíte RSpec**: Alinhamento dos parâmetros e mocks nos testes de requisição (`users_spec.rb` e testes de serviço), resolvendo divergências de chaves (`with_indifferent_access`), corrigindo falsos negativos de erro 404 e validando o instanciamento correto em views (`TemplatesController`).
### Responsável: Davi Brasileiro Gomes
- **Refatoramento das pastas /forms, /results, /templates e /answerable_forms das features** : Implementação da etapa "Yellow" do TDD nas pastas, garantindo testes RSpec com êxito e a manutenção do funcionamento da aplicação;
- **Geração da documentação com o RDoc**: Adequação dos comentários inseridos nos códigos da aplicação para o melhor funcionamento da gema, considerando necessidades do projeto e a boa compreensão dos componentes chave por meio das páginas HTML;

### Responsável: Roberto Ribeiro Corrêa Neto
- **Redução de complexidade (ABC Score) com RubyCritic**: Refatoração dos métodos com pontuação ABC alta (Extract Method), trazendo o maior valor do projeto de 31.0 para 18.3, com todos os métodos abaixo do limite de 20 exigido pela sprint;
- **Eliminação de código duplicado nas controladoras**: Aplicação de _Move Method / Extract Class_ para mover a lógica duplicada de upsert de turmas, usuários e matrículas (presente em `UsersController` e `SigaaUpdatesController`) para os Models `Turma`, `User` e `Enrollment`, retirando o `UsersController` da nota D do RubyCritic (duplicação de 83 para 0);
- **Implementação do serviço `SigaaImporter` (#14)**: Criação do `app/services/sigaa_importer.rb` (`SigaaImporter.call`) que importa turmas, usuários e matrículas do JSON do SIGAA de forma idempotente, destravando a suíte RSpec (que não carregava por falta da classe) e elevando a cobertura geral para 98.76%;
- **Cobertura de testes RSpec com SimpleCov (Happy/Sad Path)**: Configuração do SimpleCov (merge RSpec/Cucumber) e criação de specs para todos os controllers/models/serviços/mailers, cobrindo Happy e Sad Path. Resultado: **96 exemplos RSpec, 0 falhas**, todos os componentes acima de 90% e os **53 cenários do Cucumber** intactos;

## Resultados da Refatoração (antes × depois):

### Complexidade — ABC Score por método (RubyCritic / Flog, limite < 20):

| Método | Antes | Depois | Técnica |
|--------|------:|-------:|---------|
| `PendingRegistrationsController#update` | 31.0 | 17.6 | Extract Method (`atributos_do_usuario`) |
| `UsersController#register_participants` | 30.1 | 11.7 | Extract Method (`processar_participante`, `registrar_pendente`) |
| `UsersController#create` | 26.1 | 18.3 | Extract Method (`parametros_convite`) |
| `PasswordRedefinitionController#update` | 24.1 | 14.0 | Extract Method (`redirecionar_se_invalida`, `redefinir_senha`) |
| `FormulariosController#index` | 19.6 | 8.x | Extract Method (`carregar_formularios_do_discente`) |
| `FormulariosController#gerar_csv` | 19.6 | 8.x | Extract Method (`escrever_cabecalho_csv`) |
| **Maior ABC do projeto** | **31.0** | **18.3** | — |

Duplicação de código no `UsersController`: **83 → 0** (lógica de upsert movida para os Models via _Move Method / Extract Class_), elevando a nota do arquivo de **D → C**. Score geral do RubyCritic: **91.55 → 93.59**.

### Cobertura de testes (SimpleCov / RSpec, limite > 90%):

| Componente | Antes | Depois |
|-----------|------:|-------:|
| Suíte RSpec | não carregava (0%) | **98.76%** |
| Arquivos abaixo de 90% | ~11 | **0** |
| `UsersController` | 53% | 100% |
| `ResultadosController` | 62% | 100% |
| `PendingRegistrationsController` | 55% | 100% |
| `PasswordRedefinitionController` | 74% | 100% |
| `SigaaImporter` (serviço) | 78% | 100% |
| Menor cobertura do projeto | 0% | **91.67%** (`ApplicationController`) |

## Estratégia de *branching*:
Para a Sprint 3, consolidamos as implementações na branch `sprint-3`. Os merges foram realizados e testados localmente, garantindo a integridade do sistema e a resolução de conflitos (incluindo chaves do Rails). Como o propósito da sprint era a refatoração e a documentação, aproveitamos a estrutura do projeto já consolidada para apenas fazer Commits estratégicos e pontuais, com manutenção das funcionalidades desenvolvidas.
