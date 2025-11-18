# Sprint 1 — Especificação de Testes de Aceitação (BDD)

## Integrantes
- Gabriel Caixeta Romero – 232036896  
- Gustavo Henrique Andrade Cavalcanti – 222034109  
- Vitor Amorim Mello – 231037048  

## Projeto
CAMAAR – Sistema de Avaliação de Turmas da UnB

## Escopo do Projeto
O CAMAAR é um sistema para avaliação de turmas, permitindo que administradores gerenciem turmas, formulários e dados do SIGAA, enquanto participantes respondem formulários vinculados às turmas em que estão matriculados.

---

## Papéis da Equipe
- **Scrum Master:** Gabriel Caixeta Romero  
- **Product Owner:** Gustavo Henrique Andrade Cavalcanti  

---

## Objetivo da Sprint
Especificar **todos os cenários de teste de aceitação (BDD)** utilizando Gherkin. Não houve implementação funcional, apenas documentação de comportamento.

---

## Funcionalidades e Regras de Negócio

### Autenticação
- Login por e-mail/matrícula  
- Definição e redefinição de senha  
- Diferenciação entre usuários e administradores  

### SIGAA
- Importação e atualização de dados  
- Cadastro automático de usuários importados  

### Formulários
- Participantes respondem formulários pendentes  
- Administradores criam templates, editam e deletam  
- Criação de formulários para docentes/discentes  

### Relatórios
- Visualização de resultados  
- Exportação CSV  

### Departamentos
- Administradores gerenciam apenas seu próprio departamento  

---

## Responsáveis por Cada Funcionalidade (com link para arquivo `.feature`)

### Gustavo — Issues #98 a #103
- [#98 Importar dados do SIGAA](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/importar_sigaa.feature)
- [#99 Responder formulário](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/responder_formulario.feature)  
- [#100 Cadastrar usuários](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/cadastrar_usuarios.feature)
- [#101 Gerar relatório (CSV)](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/gerar_relatorio.feature) 
- [#102 Criar template](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/criar_template.feature) 
- [#103 Criar formulário de avaliação](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/criar_formulario_avaliacao.feature)

### Gabriel — Issues #104 a #109
- [#104 Login](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/login.feature)
- [#105 Definição de senha](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/definicao_senha.feature)
- [#106 Gerenciamento por departamento](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/gerenciamento_departamento.feature)
- [#107 Redefinição de senha](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/redefinicao_senha.feature)
- [#108 Atualizar base com dados do SIGAA](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/atualizar_base_sigaa.feature)
- [#109 Visualizar formulários para responder](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/visualizar_formularios.feature)

### Vitor — Issues #110 a #113
- [#110 Visualizar resultados dos formulários](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/visualizar_resultados_formularios.feature)
- [#111 Visualização dos templates criados](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/visualizar_templates.feature)
- [#112 Edição e deleção de templates](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/editar_deletar_templates.feature)
- [#113 Criar formulário para docentes ou dicentes](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/criar_formulario_docentes.feature)

---

## Política de Branching
- Branch principal: `main`  
- Branch da sprint: `sprint-1`  
- **Cada integrante adicionava diretamente seus arquivos `.feature` na branch `sprint-1`**  
- Sem branches individuais por funcionalidade  
- Ao final, PR consolidou a sprint  

---

## Backlog da Sprint 1

| ID | História | Tipo | Arquivo `.feature` | Status |
|----|----------|------|--------------------|--------|
| #98 | Importar dados do SIGAA | Administrador | [importar_sigaa.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/importar_sigaa.feature) | Concluída |
| #99 | Responder formulário | Participante | [responder_formulario.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/responder_formulario.feature) | Concluída |
| #100 | Cadastrar usuários | Administrador | [cadastrar_usuarios.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/cadastrar_usuarios.feature) | Concluída |
| #101 | Gerar relatório | Administrador | [gerar_relatorio.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/gerar_relatorio.feature) | Concluída |
| #102 | Criar template | Administrador | [criar_template.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/criar_template.feature) | Concluída |
| #103 | Criar formulário de avaliação | Administrador | [criar_formulario_avaliacao.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/criar_formulario_avaliacao.feature) | Concluída |
| #104 | Login | Usuário | [login.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/login.feature) | Concluída |
| #105 | Definição de senha | Usuário | [definicao_senha.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/definicao_senha.feature) | Concluída |
| #106 | Gerenciamento por departamento | Administrador | [gerenciamento_departamento.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/gerenciamento_departamento.feature) | Concluída |
| #107 | Redefinição de senha | Usuário | [redefinicao_senha.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/redefinicao_senha.feature) | Concluída |
| #108 | Atualizar base com SIGAA | Administrador | [atualizar_base_sigaa.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/atualizar_base_sigaa.feature) | Concluída |
| #109 | Visualizar formulários | Participante | [visualizar_formularios.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/visualizar_formularios.feature) | Concluída |
| #110 | Visualizar resultados | Administrador | [visualizar_resultados_formularios.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/visualizar_resultados_formularios.feature) | Concluída |
| #111 | Visualizar templates | Administrador | [visualizar_templates.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/visualizar_templates.feature) | Concluída |
| #112 | Edição/deleção de templates | Administrador | [editar_deletar_templates.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/editar_deletar_templates.feature) | Concluída |
| #113 | Formulário para docentes/discentes | Administrador | [criar_formulario_docentes.feature](https://github.com/GustavoHCavalcanti/CAMAAR/blob/sprint-1/features/criar_formulario_docentes.feature) | Concluída |

---

## Pontuação (Velocity)
Cada história recebeu **1 ponto**.  
Total da Sprint 1: **16 pontos entregues**.

---

## Artefatos Entregues
- Todos os 16 arquivos `.feature` concluídos.  
- Pull Request consolidando a sprint.  
- Arquivo `.txt` entregue com dados do grupo e link para o repositório.  

---

## Resumo Técnico da Sprint
- Todas as regras de negócio foram traduzidas para cenários BDD claros e verificáveis.  
- Cenários completos incluem fluxos felizes e casos de erro.  
- Estrutura padronizada (Given/When/Then).  
- Divisão de responsabilidades mantida conforme as issues da sprint.  

---

## Dificuldades Encontradas
- Nivelamento da granularidade entre membros.  
- Interpretação de regras implícitas nas issues.  
- Padronização dos arquivos `.feature`.  

---

## Conclusão
A Sprint 1 cumpriu integralmente seu objetivo, entregando a especificação comportamental completa do sistema.  
A equipe encontra-se preparada para iniciar a etapa de implementação com base sólida de critérios de aceite.