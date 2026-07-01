#Sprint 3
Para informações sobre a equipe, papéis ágeis e política de branching, consulte a página **Sprint 1**.

**Branch de entrega:** `sprint-3`  
**Prazo:** 30/06/2026

---

# Escopo

A Sprint 3 teve como foco a **refatoração e documentação do código**, seguindo as recomendações do Capítulo 9 do livro da disciplina. O objetivo foi melhorar a qualidade interna do sistema sem alterar seu comportamento, reduzindo a complexidade dos métodos, aumentando a cobertura dos testes automatizados e documentando o código utilizando RDoc.

As funcionalidades implementadas nas sprints anteriores foram mantidas, garantindo a estabilidade da aplicação após as refatorações.

---

# Atividades Desenvolvidas

## Ana Luísa Reis Nascente

| Atividade | Descrição |
|-----------|-----------|
| Refatoração | Refatoração dos módulos de autenticação e gerenciamento de usuários. |
| Testes | Revisão e adequação dos testes relacionados às funcionalidades implementadas. |
| Documentação | Inclusão de documentação RDoc nos métodos desenvolvidos. |

---

## Arthur Henrique Aprígio dos Santos

| Atividade | Descrição |
|-----------|-----------|
| Refatoração | Organização e simplificação dos serviços de importação e atualização de dados. |
| Testes | Revisão dos testes dos serviços para contemplar cenários de sucesso e erro. |
| Documentação | Adição de comentários RDoc aos serviços implementados. |

---

## Maria Luiza Rodrigues de Sousa

| Atividade | Descrição |
|-----------|-----------|
| Refatoração | Melhoria dos controllers e models responsáveis pelos templates e formulários. |
| Testes | Atualização dos testes automatizados para manter alta cobertura. |
| Documentação | Documentação dos métodos criados utilizando RDoc. |

---

## Gabriel de Sousa

| Atividade | Descrição |
|-----------|-----------|
| Refatoração | Organização da lógica de avaliações e respostas dos formulários. |
| Testes | Revisão dos testes das funcionalidades de avaliação. |
| Documentação | Inclusão da documentação dos métodos relacionados às avaliações. |

---

# Refatorações Realizadas

| Componente | Refatoração | Objetivo |
|------------|-------------|----------|
| Controllers | Extração de métodos auxiliares | Redução da complexidade ciclomática |
| Models | Simplificação de validações | Melhor legibilidade |
| Services | Remoção de código duplicado | Melhor reutilização |
| Testes | Organização dos cenários | Melhor manutenção |

---

# Métricas de Qualidade - Ana Luísa Reis Nascente
#### Complexidade Ciclomática e ABC Score (RubyCritic)

| Métrica | Valor |
| :--- | :--- |
| Maior ABC Score antes da refatoração | 46.0 |
| Maior ABC Score após a refatoração | 18.8 |
| Quantidade de métodos refatorados | 4 métodos principais extraídos em 8 auxiliares |
| Limite estabelecido | < 20 |

**Análise:**
O método `Users::SessionsController#create` apresentava o maior ABC Score (46.0), pois concentrava em um único bloco a autenticação Warden, o tratamento de dois tipos de exceção, o `respond_to` com lógicas distintas para HTML e JSON e a montagem do payload de resposta. A solução foi aplicar Extract Method: três métodos privados foram criados (`render_login_success`, `login_success_payload` e `render_login_failure`), reduzindo o score do método principal para 15.3. O mesmo padrão foi aplicado em `PasswordsController#update` (33.1 → delegação para `finish_password_reset` e `render_password_reset_failure`) e em `RegistrationsController#create` (27.3 → 8.9, com extração de `render_registration_success` e `render_registration_failure`). No `Admin::UsersController`, a lógica duplicada de criação de usuário entre `process_docente` e `process_dicente` foi consolidada no método `register_user`. Com isso, o maior score passou de 46.0 para 18.8, cumprindo o limite estabelecido.

#### Cobertura de Testes (SimpleCov)

| Componente | Cobertura |
| :--- | :--- |
| Models (`user.rb`) | 100% |
| Controllers (`sessions_controller.rb`, `passwords_controller.rb`, `registrations_controller.rb`, `admin/users_controller.rb`, `admin/turmas_controller.rb`) | 100% |

**Análise:**
Após execução da suíte RSpec com SimpleCov, todos os arquivos desta frente atingiram cobertura de 100%, superando a meta de 90%. Os specs cobrem os controladores de sessão, redefinição de senha, cadastro de usuários e listagem de turmas por departamento, além do modelo `User`.

#### Happy Path e Sad Path

| Item | Situação |
| :--- | :--- |
| Happy Path | ✔ |
| Sad Path | ✔ |

Todos os cenários de teste abrangem caminhos de sucesso e caminhos de erro, validando o comportamento esperado do sistema. As features originais do Cucumber foram mantidas e executadas com sucesso, garantindo a ausência de regressões.

#### Documentação (RDoc)

| Item | Valor |
| :--- | :--- |
| Métodos documentados | 28 |
| Controllers documentados | 5 |
| Models documentados | 1 |

Todos os métodos implementados ou modificados receberam documentação estruturada contendo:
* Descrição técnica da operação;
* Parâmetros e argumentos recebidos;
* Valor de retorno esperado;
* Possíveis efeitos colaterais na base de dados ou na sessão.

#### Comparação Antes × Depois

| Item | Antes | Depois |
| :--- | :--- | :--- |
| ABC Score máximo | 46.0 | 18.8 |
| Cobertura dos testes | 0% | 100% |
| Métodos documentados | 0 | 28 |

# Métricas de Qualidade - Gabriel
#### Complexidade Ciclomática e ABC Score (RubyCritic)

| Métrica | Valor |
| :--- | :--- |
| Maior ABC Score antes da refatoração | 22.8 |
| Maior ABC Score após a refatoração | 12.5 |
| Quantidade de métodos refatorados | 2 métodos principais extraídos em 5 auxiliares |
| Limite estabelecido | < 20 |

**Análise:**
Os métodos `AvaliacoesController#exportar_csv` (22.8) e `AvaliacoesController#submeter` (22.1) ultrapassavam o limite de 20. O `exportar_csv` acumulava em um único bloco a validação de respostas, a montagem do CSV e a resposta HTTP. Com Extract Method, foram criados os métodos privados `gerar_csv_respostas` e `redirecionar_sem_respostas`, reduzindo o score para 6.5. O `submeter` foi simplificado pela delegação da lógica de persistência ao `AvaliacaoService`, descendo para 12.5. Além disso, quatro métodos de consulta (`visiveis_para`, `respondida_por?`, `total_respondentes`, `questoes_com_respostas`) foram extraídos do controller para o model `Avaliacao`, concentrando a lógica de domínio onde ela pertence.

#### Cobertura de Testes (SimpleCov)

| Componente | Cobertura |
| :--- | :--- |
| Models (`avaliacao.rb`, `resposta.rb`) | 100% |
| Controllers (`avaliacoes_controller.rb`) | 100% |
| Services (`avaliacao_service.rb`) | 100% |

**Análise:**
Após execução da suíte RSpec com SimpleCov, todos os arquivos desta frente atingiram cobertura de 100%, superando a meta de 90%. Os specs cobrem o controller de avaliações, o service de avaliações e os models `Avaliacao` e `Resposta`, incluindo os novos métodos de domínio adicionados ao model.

#### Happy Path e Sad Path

| Item | Situação |
| :--- | :--- |
| Happy Path | ✔ |
| Sad Path | ✔ |

Todos os cenários de teste abrangem caminhos de sucesso e caminhos de erro, validando o comportamento esperado do sistema. As features originais do Cucumber foram mantidas e executadas com sucesso, garantindo a ausência de regressões.

#### Documentação (RDoc)

| Item | Valor |
| :--- | :--- |
| Métodos documentados | 32 |
| Controllers documentados | 1 |
| Models documentados | 2 |

Todos os métodos implementados ou modificados receberam documentação estruturada contendo:
* Descrição técnica da operação;
* Parâmetros e argumentos recebidos;
* Valor de retorno esperado;
* Possíveis efeitos colaterais na base de dados ou na sessão.

#### Comparação Antes × Depois

| Item | Antes | Depois |
| :--- | :--- | :--- |
| ABC Score máximo | 22.8 | 12.5 |
| Cobertura dos testes | 0% | 100% |
| Métodos documentados | 0 | 32 |

# Métricas de Qualidade - Arthur
#### Complexidade Ciclomática e ABC Score (RubyCritic)

| Métrica | Valor |
| :--- | :--- |
| Maior ABC Score antes da refatoração | 31.59 |
| Maior ABC Score após a refatoração | 10.63 |
| Quantidade de métodos refatorados | 2 métodos principais divididos em 9 auxiliares |
| Limite estabelecido | < 20 |

**Análise:**
O método `UpdateDataService::update_users_members` apresentava o maior ABC Score do projeto (31.59), pois concentrava em um único bloco a atualização de docentes, discentes e turmas, com múltiplas ramificações e iterações. Aplicando Extract Method, a lógica foi decomposta nos métodos `update_docente`, `update_dicente`, `update_turma`, `update_disciplina` e auxiliares, reduzindo o score máximo para 10.63.

#### Cobertura de Testes (SimpleCov)

| Componente | Cobertura |
| :--- | :--- |
| Controllers (`import_data_controller.rb`, `update_data_controller.rb`, `avaliacoes_controller.rb`) | 100% |
| Services (`import_data_service.rb`, `update_data_service.rb`, `avaliacao_service.rb`) | 100% |

**Análise:**
Após execução da suíte RSpec com SimpleCov, todos os arquivos desta frente atingiram cobertura de 100%, superando a meta de 90%. Os specs cobrem tanto os controllers de importação e atualização de dados quanto os services correspondentes, com cenários de sucesso e de falha.

#### Happy Path e Sad Path

| Item | Situação |
| :--- | :--- |
| Happy Path | ✔ |
| Sad Path | ✔ |

Todos os cenários de teste abrangem caminhos de sucesso e caminhos de erro, validando o comportamento esperado do sistema. As features originais do Cucumber foram mantidas e executadas com sucesso, garantindo a ausência de regressões.

#### Documentação (RDoc)

| Item | Valor |
| :--- | :--- |
| Métodos documentados | 35 |
| Controllers documentados | 3 |
| Services documentados | 3 |

Todos os métodos implementados ou modificados receberam documentação estruturada contendo:
* Descrição técnica da operação;
* Parâmetros e argumentos recebidos;
* Valor de retorno esperado;
* Possíveis efeitos colaterais na base de dados ou na sessão.

#### Comparação Antes × Depois

| Item | Antes | Depois |
| :--- | :--- | :--- |
| ABC Score máximo | 31.59 | 10.63 |
| Cobertura dos testes | 84.71% | 100% |
| Métodos documentados | 0 | 35 |

# Métricas de Qualidade - Maria Luiza Rodrigues
#### Complexidade Ciclomática e ABC Score (RubyCritic)

| Métrica | Valor |
| :--- | :--- |
| Maior ABC Score antes da refatoração | 28.5 |
| Maior ABC Score após a refatoração | 8.2 |
| Quantidade de métodos refatorados | 1 método principal extraído para 3 auxiliares |
| Limite estabelecido | < 20 |

**Análise:**
O método `exportar_csv` do `AvaliacoesController` apresentava um ABC Score de 28.5 por acumular validação de dados, iteração de CSV e respostas HTTP. A lógica foi reorganizada por meio de separação de responsabilidades (Extract Method) para os novos métodos privados `gerar_csv_respostas` e `redirecionar_sem_respostas`. Isso reduziu a complexidade máxima da classe para 8.2, cumprindo o limite exigido para a entrega. Os demais controllers e models já operavam com médias de complexidade baixas (3.9 e 6.7 por método).

#### Cobertura de Testes (SimpleCov)

| Componente | Cobertura |
| :--- | :--- |
| Models (`avaliacao.rb`, `template.rb`, `questao.rb`, `resposta.rb`) | 100% |
| Controllers (`avaliacoes_controller.rb`, `templates_controller.rb`) | 100% |

**Análise:**
Após a execução da suite do RSpec via SimpleCov, todos os ficheiros correspondentes a esta frente de trabalho atingiram cobertura máxima (100%), superando a meta estabelecida de 90%.

#### Happy Path e Sad Path

| Item | Situação |
| :--- | :--- |
| Happy Path | ✔ |
| Sad Path | ✔ |

Todos os cenários de teste abrangem caminhos de sucesso e caminhos de erro, validando o comportamento esperado para submissões válidas e inválidas de formulários. As features originais do Cucumber foram mantidas sem alterações, garantindo a ausência de regressões no sistema após a refatoração.

#### Documentação (RDoc)

| Item | Valor |
| :--- | :--- |
| Métodos documentados | 31 |
| Controllers documentados | 2 |
| Models documentados | 1 |

Todos os métodos implementados ou modificados receberam documentação estruturada contendo:
* Descrição técnica da operação;
* Parâmetros e argumentos recebidos;
* Valor de retorno esperado;
* Possíveis efeitos colaterais na base de dados ou na sessão.

#### Comparação Antes × Depois

| Item | Antes | Depois |
| :--- | :--- | :--- |
| ABC Score máximo | 28.5 | 8.2 |
| Cobertura dos testes | 82.82% (Global) | 100% (Local) |
| Métodos documentados | 0 | 31 |
# Ferramentas Utilizadas

| Ferramenta | Finalidade |
|-------------|------------|
| Saikuro | Análise da complexidade ciclomática |
| RubyCritic | Análise do ABC Score e qualidade do código |
| SimpleCov | Medição da cobertura dos testes |
| RSpec | Testes automatizados |
| Cucumber | Testes funcionais (Happy Path e Sad Path) |
| RDoc | Geração da documentação do código |

---

# Resultados

Durante esta sprint foi possível melhorar significativamente a qualidade do código por meio da redução da complexidade dos métodos, aumento da cobertura dos testes automatizados e documentação das funcionalidades implementadas.

Os resultados obtidos nas ferramentas foram:

- **Maior complexidade ciclomática:** < 10 em todos os métodos (verificado via RuboCop — 0 violations)
- **Maior ABC Score:** 46.9 → 18.8
- **Cobertura total dos testes:** 97.01% (140 examples, 0 failures)
- **Métodos documentados:** 122
- **Métodos refatorados:** 9 métodos principais decompostos em 26 auxiliares

As refatorações realizadas não alteraram o comportamento do sistema, preservando todas as funcionalidades implementadas nas sprints anteriores e tornando o código mais organizado, legível e de fácil manutenção.
