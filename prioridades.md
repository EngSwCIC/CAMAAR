# CAMAAR - Sprint 2: Priorização de Issues
**Product Owner**: [Seu nome]  
**Data**: 29 de maio de 2026  
**Total de Issues**: 17

---

## 📊 Matriz de Priorização

| Prioridade | Issues | Critério |
|---|---|---|
| 🔴 **P0 - CRÍTICO** | #13, #12, #17 | Bloqueadores - Precisam estar prontos para qualquer outra funcionalidade |
| 🟠 **P1 - ALTA** | #15, #14, #8, #18 | Funcionalidades core do negócio (templates, formulários, respostas) |
| 🟡 **P2 - MÉDIA** | #11, #16, #9 | Gerenciamento e relatórios (importante mas não bloqueia MVP) |
| 🔵 **P3 - BAIXA** | #10, #19 | Melhorias/Integrações (podem ser feitas depois) |

---

## 🎯 PRIORIDADE 0 - CRÍTICOS (Sprint 2)

Estas issues **DEVEM ser concluídas antes de qualquer outra**. Sem elas, nenhuma funcionalidade funciona.

### **1. #17 - Cadastrar usuários do sistema** 
- **Status**: 🔴 P0 - CRÍTICO
- **Assignee**: [Definir]
- **Esforço**: Grande (G)
- **Dependência**: Nenhuma
- **Por quê?** Sem usuários cadastrados, não há login, não há respostas, não há formulários. Precisa estar pronta **antes de tudo**.
- **Descrição**: Criar seed/script para popular a base com docentes e discentes do SIGAA via `class_members.json` e `classes.json`
- **Critério de Aceitação**:
  - Usuários criados via migration/seed com perfil correto (docente/discente)
  - Senhas hash geradas (primeiro acesso = true)
  - Vínculo com Docente e Discente criado
  - Todas as matrículas de turmas populadas

### **2. #13 - Sistema de Login**
- **Status**: 🔴 P0 - CRÍTICO
- **Assignee**: Anarayssa-dev
- **Esforço**: Médio (M)
- **Dependência**: #17 (usuários existirem)
- **Por quê?** É o **portão de entrada** do sistema. Sem login, ninguém acessa nada.
- **Descrição**: Implementar autenticação com e-mail ou matrícula + senha. Rails: usar Devise ou implementar via sessions.
- **Critério de Aceitação**:
  - Login com e-mail **OU** matrícula (campo login em Usuario)
  - Validação de senha hash
  - Primeira vez = redireção para mudança de senha (issue #12)
  - Admin logado vê menu de gerenciamento
  - Logout funciona
  - Guard em todas as rotas (apenas autenticados acessam)

### **3. #12 - Sistema de definição de senha**
- **Status**: 🔴 P0 - CRÍTICO
- **Assignee**: [Definir]
- **Esforço**: Pequeno (P)
- **Dependência**: #13 (login está pronto)
- **Por quê?** Na primeira vez que o usuário loga, ele **deve mudar a senha padrão**. Bloqueador de segurança e UX.
- **Descrição**: Tela de redefinição de senha no primeiro acesso (flag `primeiro_acesso=true`).
- **Critério de Aceitação**:
  - Ao fazer login com `primeiro_acesso=true`, é redirecionado para `/usuarios/mudar-senha`
  - Valida força da senha (mín 8 caracteres, maiúscula, número)
  - Após confirmação, `primeiro_acesso=false` e redireciona para dashboard
  - Hash da nova senha salvo corretamente em Usuario

---

## 🟠 PRIORIDADE 1 - ALTA (Sprint 2)

Estas são as funcionalidades **core do negócio**. Começam assim que o P0 estiver 80%+ pronto.

### **4. #15 - Criar template de formulário** ⭐
- **Status**: 🟠 P1 - ALTA
- **Assignee**: rafaelcarvalhoj
- **Esforço**: Grande (G)
- **Dependência**: #13, #12, #17 (autenticação pronta + usuários como docentes)
- **Por quê?** É o **pilar técnico do spike** (views, templates, forms do Rails). Alinha 100% com o MER (Template, QuestaoTemplate, OpcaoQuestao).
- **Descrição**: Implementar CRUD de templates com:
  - Criar template (titulo, descricao, docente_id)
  - Adicionar questões ao template (enunciado, tipo: aberta/multipla)
  - Se multipla → adicionar opções (texto, questao_template_id)
  - Editar/deletar template e questões
  - Listar templates criados pelo docente logado
- **Views Rails necessárias**:
  - `templates/new` e `templates/edit` (form para template)
  - `questao_templates/new` e `questao_templates/edit` (nested form para questões)
  - `templates/show` (visualizar template completo)
  - `templates/index` (listar templates do docente)
- **Critério de Aceitação**:
  - Template pode ter múltiplas questões
  - Questão salva com tipo correto
  - Opção pertence a uma questão (FK: questao_template_id)
  - Somente docente que criou pode editar/deletar
  - Validações: titulo obrigatório, mín 1 questão para salvar

### **5. #14 - Criar formulário de avaliação**
- **Status**: 🟠 P1 - ALTA
- **Assignee**: [Definir]
- **Esforço**: Médio (M)
- **Dependência**: #15 (templates existem)
- **Por quê?** A avaliação **depende de templates**. Docente cria template → gera formulário → discentes respondem.
- **Descrição**: Implementar CRUD de formulários (Formulario):
  - Selecionar template + turma + prazo
  - Criar formulário (puxa questões do template para a tabela Questao)
  - Editar/deletar apenas se nenhum discente respondeu ainda
  - Visualizar quem respondeu (listar EnvioFormulario)
- **Views Rails**:
  - `formularios/new` (form: selecionar template, turma, prazo)
  - `formularios/show` (listar questões do formulário, status de respostas)
  - `formularios/index` (listar formulários da turma do docente)
- **Critério de Aceitação**:
  - Formulário instancia questões do template (cria registros em Questao com FK para template_id)
  - Prazo armazenado (datetime)
  - Turma_id + docente_id associados corretamente
  - Não permite editar se houver envios (EnvioFormulario)

### **6. #8 - Visualização de formulários para responder**
- **Status**: 🟠 P1 - ALTA
- **Assignee**: [Definir]
- **Esforço**: Pequeno (P)
- **Dependência**: #14 (formulários existem), #17 (discentes existem)
- **Por quê?** Discente precisa **ver** o formulário antes de responder. É a interface "de leitura".
- **Descrição**: Listar formulários que o discente logado ainda não respondeu (via turmas que está matriculado).
- **Views**:
  - `formularios/listar` (filtrar: minha turma, prazo aberto, não respondido ainda)
  - `formularios/show` (ver questões, tipo, opções se multipla)
- **Critério de Aceitação**:
  - Mostra apenas formulários de turmas que o discente está matriculado
  - Mostra apenas se EnvioFormulario NÃO existe para (discente_id, formulario_id)
  - Mostra status: "Aberto" se dentro do prazo, "Fechado" se passou
  - Botão para responder (vai para #18)

### **7. #18 - Responder formulário** ⭐
- **Status**: 🟠 P1 - ALTA
- **Assignee**: [Definir]
- **Esforço**: Médio (M)
- **Dependência**: #8 (listar formulários), #14 (formulários existem)
- **Por quê?** É a **funcionalidade principal do discente**. Alinha com EnvioFormulario + Resposta do MER.
- **Descrição**: Implementar fluxo completo de resposta:
  - Exibir formulário (questões com tipo aberta/multipla)
  - Se multipla → radio buttons das opções (OpcaoQuestao)
  - Se aberta → textarea para resposta
  - Validar: todas as questões respondidas
  - Salvar EnvioFormulario (1x por discente) + registros em Resposta (1 por questão)
- **Views**:
  - `envios_formularios/new` (form dinâmico com questões do formulário)
  - `envios_formularios/show` (mostra a resposta já enviada - read-only)
- **Critério de Aceitação**:
  - EnvioFormulario criado com (formulario_id, discente_id) - UNIQUE constraint respeitado
  - Cada Resposta tem (envio_id, questao_id, conteudo)
  - Descenta erro se tentar responder 2x o mesmo formulário
  - Timestamp de envio registrado
  - Após envio → redireciona para dashboard com mensagem de sucesso

---

## 🟡 PRIORIDADE 2 - MÉDIA (Sprint 2 ou 3)

Funções administrativas e relatórios. **Importantes mas não bloqueiam MVP**. Podem começar em paralelo se houver recursos.

### **8. #11 - Sistema de gerenciamento por departamento**
- **Status**: 🟡 P2 - MÉDIA
- **Assignee**: [Definir]
- **Esforço**: Médio (M)
- **Dependência**: #13 (admin logado), #15, #14 (formulários existem)
- **Por quê?** Admin gerencia docentes por departamento. Alinha com o MER (Departamento é entidade própria agora).
- **Descrição**: Views para admin:
  - Listar departamentos
  - Criar/editar departamentos
  - Listar docentes de um departamento
  - Visualizar formulários criados por docentes do departamento
  - Gerar relatórios por departamento
- **Critério de Aceitação**:
  - Somente usuários com perfil 'admin' acessam
  - Docente tem FK para departamento
  - Filtro por departamento nas views

### **9. #16 - Gerar relatório do administrador**
- **Status**: 🟡 P2 - MÉDIA
- **Assignee**: [Definir]
- **Esforço**: Médio (M)
- **Dependência**: #18 (respostas existem), #11 (departamentos gerenciados)
- **Por quê?** Relatórios têm **valor agregado** mas não são funcionalidade bloqueadora.
- **Descrição**: Admin pode gerar relatório com:
  - Número de discentes por turma
  - Taxa de resposta por formulário (% que responderam)
  - Estatísticas por departamento
  - Export em CSV/PDF
- **Critério de Aceitação**:
  - Relatório filtra por departamento/turma/período
  - Mostra dados agregados de Resposta
  - Pode ser exportado

### **10. #9 - Atualizar base de dados com os dados do SIGAA**
- **Status**: 🟡 P2 - MÉDIA
- **Assignee**: [Definir]
- **Esforço**: Pequeno (P)
- **Dependência**: #17 (primeiro carregamento feito)
- **Por quê?** Precisa sincronizar SIGAA periodicamente (rake task). Mas primeira carga já funciona em #17.
- **Descrição**: Implementar rake task que:
  - Lê `class_members.json` e `classes.json` novamente
  - Atualiza usuários, turmas, matrículas
  - Cria novos usuários se surgiram
  - Desativa usuários que saíram
- **Critério de Aceitação**:
  - Task `rake camaar:sync_sigaa` roda sem erros
  - Logs indicam quantos registros foram atualizados/criados

---

## 🔵 PRIORIDADE 3 - BAIXA (Sprint 3+)

Funcionalidades que **agregam valor mas podem esperar**. Segundo MVP.

### **11. #10 - Redefinição de senha**
- **Status**: 🔵 P3 - BAIXA
- **Assignee**: [Definir]
- **Esforço**: Pequeno (P)
- **Dependência**: #13 (login pronto)
- **Por quê?** Usuário esqueceu senha. Importante para UX mas não é bloqueador.
- **Descrição**: Fluxo:
  - Link "Esqueci minha senha" na tela de login
  - Insere e-mail
  - Recebe link de reset por e-mail (token temporário)
  - Clica link → define nova senha
  - Volta a logar com nova senha

### **12. #19 - Importar dados do SIGAA**
- **Status**: 🔵 P3 - BAIXA
- **Assignee**: [Definir]
- **Esforço**: Grande (G)
- **Dependência**: #17 (primeira carga feita)
- **Por quê?** **Integrações externas** são complexas. O MVP funciona com dados estáticos em `class_members.json`. Integração com SIGAA pode vir depois.
- **Descrição**: Conectar à API do SIGAA (ou scraping) para trazer dados em tempo real.
- **Nota**: Pode ser feito em Sprint 3 ou posterior. Por enquanto, usar CSV/JSON.

---

## 📈 Roadmap da Sprint 2

```
SEMANA 1
├─ P0 #17 (50%) - Cadastrar usuários
├─ P0 #13 (início) - Login
└─ P0 #12 (planejamento)

SEMANA 2
├─ P0 #13 (80%)
├─ P0 #12 (100%)
├─ P1 #15 (início) - Template
└─ P1 #14 (planejamento)

SEMANA 3
├─ P1 #15 (80%)
├─ P1 #14 (50%)
├─ P1 #8 (início) - Listar formulários
└─ P2 #11 (planejamento) ← Se houver recursos

SEMANA 4
├─ P1 #14 (100%)
├─ P1 #8 (100%)
├─ P1 #18 (início/end) - Responder
├─ P2 #9 (100%) - Sync SIGAA
└─ BUFFER para testes e refine
```

---

## ⚠️ Riscos & Observações

| Risco | Mitigation | Owner |
|-------|-----------|-------|
| Spike técnico de Rails (forms, nested routes) pode atrasar #15 | Documentar padrão, pair programming | Tech Lead |
| Mudança no MER pode impactar #13-#18 | MER está **FINAL**. Congelar para Sprint 2. | PO |
| Sincronização SIGAA (#9) pode ter problemas de formato | Usar dados estáticos (class_members.json) na Sprint 2 | Dev |
| Login (#13) é crítico → testes automatizados obrigatórios | TDD desde o início | Dev |
| Constraint UNIQUE em EnvioFormulario (#18) evita duplicatas | Validação em model + migration com `add_index` | DB |

---

## ✅ Critérios de Definição de Pronto (DoD)

Cada issue **só pode sair para Pronto quando**:

- [ ] Code review aprovado
- [ ] Testes unitários + integração cobrindo > 80% do código
- [ ] Funcionalidade testada manualmente no navegador
- [ ] Sem console warnings/errors
- [ ] Documentação atualizada (se aplicável)
- [ ] Migration/seed pronta (se DB)
- [ ] Nenhuma issue bloqueadora aberta

---

## 📝 Notas do Product Owner

**Alinhamento com MER**: Todas as issues de P0-P1 foram desenhadas para respeitar a estrutura final do banco de dados. **Nenhuma mudança no MER durante a Sprint 2.**

**Spike Técnico Rails**: O spike indicou que:
- Views devem usar `form_with` + partials para DRY
- Nested routes (`templates/:id/questao_templates/new`)
- Strong params para segurança
- Validações in model + in controller

**Métricas de sucesso ao final da Sprint 2**:
- ✅ Login + cadastro funcionando 100%
- ✅ Template + Formulário 100%
- ✅ Discente consegue responder formulário 100%
- ✅ Docente consegue visualizar respostas 100%
- ✅ Taxa de teste > 80%
- ✅ Sem bloqueadores críticos em aberto

---

**Assinado**: Product Owner  
**Data**: 29 de maio de 2026