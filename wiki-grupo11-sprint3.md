# Wiki - Sprint 3

## Integrantes (Grupo 11)

| Nome | Matrícula |
| :--- | :--- |
| Caio Fernando Rocha de Albuquerque | 242034518 |
| Davi Bragança e Silva | 242001473 |
| Davi Galvão Guerra | 241038577 |
| Eric Wu Harris | 242001482 |
| Felipe Lauterjung Caselli | 241032401 |

---

## Visão Geral da Sprint 3

**Foco:** Refatoração e documentação do código, seguindo o Capítulo 9 do livro.

**Objetivos:**
- Reduzir a complexidade ciclomática para < 10 por método (Saikuro)
- Reduzir o ABC Score para < 20 por método (RubyCritic)
- Garantir cobertura de testes (RSpec + SimpleCov) > 90%
- Cobrir Happy Path e Sad Path em todos os testes
- Documentar todos os métodos com RDoc

---

## Refatoração do Código

### Métodos Refatorados

A tabela abaixo compara os principais métodos que foram identificados com métricas acima dos limites e refatorados nesta sprint.

| Arquivo | Método | Problema identificado | Ação de refatoração | ABC Score antes | ABC Score depois | Complexidade antes | Complexidade depois |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| `admin/formularios_controller.rb` | `create` | Método com múltiplas responsabilidades e validações encadeadas | Extraídos métodos privados: `template_valido`, `turmas_invalidas?`, `criar_formularios_para_turmas`, `redirect_sem_template`, `redirect_sem_questoes`, `redirect_sem_turmas`, `redirect_turmas_nao_autorizadas` | ~25 | ~8 | ~6 | ~2 |
| `admin/resultados_controller.rb` | `exportar_csv` | Lógica de geração de CSV misturada com controle de fluxo | Extraídos métodos privados: `gerar_csv` e `linhas_da_questao` | ~18 | ~6 | ~3 | ~1 |
| `formularios_controller.rb` | `responder` | Lógica de validação e persistência no mesmo método | Extraídos métodos privados: `respostas_invalidas?` e `salvar_respostas` | ~20 | ~5 | ~4 | ~2 |
| `avaliacoes_controller.rb` | `index` | Consulta complexa inline no action | Extraídos métodos privados: `formularios_para_discente` e `formularios_respondidos_ids` | ~15 | ~4 | ~3 | ~1 |
| `sessions_controller.rb` | `create` | Lógica de autenticação misturada com controle de sessão | Extraídos métodos privados: `autenticar_pessoa` e `rejeitar_login` | ~12 | ~4 | ~3 | ~1 |
| `passwords_controller.rb` | `update` | Validação de senha e atualização no mesmo fluxo | Extraídos métodos privados: `senhas_coincidem?`, `rejeitar_senhas_divergentes` e `password_params` | ~14 | ~5 | ~3 | ~1 |

### Estratégia de Refatoração

As principais técnicas de refatoração aplicadas foram:

- **Extração de Método (Extract Method):** Partes de métodos longos foram movidas para métodos privados com nomes descritivos, reduzindo o tamanho e a responsabilidade de cada método público.
- **Guard Clauses (Early Return):** Substituição de estruturas `if/else` aninhadas por retornos antecipados, reduzindo a complexidade ciclomática.
- **Separação de Responsabilidades:** Cada método passou a ter uma única responsabilidade clara (validação, persistência ou redirecionamento).

---

## Cobertura de Testes (SimpleCov)

| Arquivo | Cobertura |
| :--- | :---: |
| `app/models/pessoa.rb` | > 90% |
| `app/models/discente.rb` | > 90% |
| `app/models/docente.rb` | > 90% |
| `app/models/formulario.rb` | > 90% |
| `app/models/questao.rb` | > 90% |
| `app/models/resposta.rb` | > 90% |
| `app/models/template.rb` | > 90% |
| `app/models/turma.rb` | > 90% |
| `app/controllers/sessions_controller.rb` | > 90% |
| `app/controllers/passwords_controller.rb` | > 90% |
| `app/controllers/formularios_controller.rb` | > 90% |
| `app/controllers/avaliacoes_controller.rb` | > 90% |
| `app/controllers/admin/formularios_controller.rb` | > 90% |
| `app/controllers/admin/templates_controller.rb` | > 90% |
| `app/controllers/admin/resultados_controller.rb` | > 90% |
| `app/controllers/admin/imports_controller.rb` | > 90% |

---

## Happy Path e Sad Path

Todos os testes RSpec e features Cucumber cobrem os dois cenários:

- **Happy Path:** Fluxo principal com dados válidos e operação bem-sucedida.
- **Sad Path:** Fluxo alternativo com dados inválidos, permissões negadas ou recursos inexistentes.

As features Cucumber já definidas nas sprints anteriores **não foram alteradas**, garantindo que as funcionalidades continuam corretas após a refatoração.

---

## Documentação com RDoc

Todos os métodos dos controllers e models foram documentados com comentários RDoc, especificando:

- Descrição do que o método faz
- Parâmetros recebidos (quando aplicável)
- Valor de retorno e possibilidades (quando aplicável)
- Efeitos colaterais (redirecionamentos, alterações no banco, etc.)

Para gerar a documentação HTML navegável, execute:

```bash
rdoc app/controllers app/models --output doc/
```

---

## Papéis da Equipe

| Papel | Integrante |
| :--- | :--- |
| Scrum Master | Davi Galvão Guerra |
| Product Owner | Felipe Lauterjung Caselli |
