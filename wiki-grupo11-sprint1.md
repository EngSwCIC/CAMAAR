# Wiki - Sprint 1

## 👥 Integrantes (Grupo 11)

| Nome | Matrícula |
| :--- | :--- |
| Caio Fernando Rocha de Albuquerque | 242034518 |
| Davi Bragança e Silva | 242001473 |
| Davi Galvão Guerra | 241038577 |
| Eric Wu Harris | 242001482 |
| Felipe Lauterjung Caselli | 241032401 |

---

## 🎯 Visão Geral do Projeto
**Projeto:** CAMAAR - Sistema para avaliação de atividades acadêmicas remotas do CIC.

**Escopo da Sprint:** O objetivo principal desta sprint é estabelecer a base de acesso e gestão do sistema. Isso inclui a autenticação segura dos usuários, o controle de acesso, a sincronização de dados acadêmicos com a base do SIGAA, e as funcionalidades fundamentais de criação, edição e submissão de formulários de avaliação.

---

## 🎭 Papéis da Equipe
* **Scrum Master:** Caio Fernando Rocha de Albuquerque
* **Product Owner:** Davi Bragança e Silva

---

## 📋 Funcionalidades, Responsáveis e Estimativas

| Issue | Funcionalidade | Responsável | Pontos (Story Points) |
| :--- | :--- | :--- | :---: |
| #101 | Gerar relatório do administrador | Caio Fernando Rocha de Albuquerque | 3 |
| #102 | Criar template de formulário | Caio Fernando Rocha de Albuquerque | 5 |
| #103 | Criar formulário de avaliação | Caio Fernando Rocha de Albuquerque | 5 |
| #105 | Sistema de definição de senha | Davi Bragança e Silva | 3 |
| #106 | Sistema de gerenciamento por departamento | Davi Bragança e Silva | 3 |
| #111 | Visualização dos templates criados | Davi Bragança e Silva | 3 |
| #98 | Importar dados do SIGAA | Davi Galvão Guerra | 5 |
| #99 | Responder formulário | Davi Galvão Guerra | 3 |
| #100 | Cadastrar usuários do sistema | Davi Galvão Guerra | 3 |
| #107 | Redefinição de senha | Eric Wu Harris | 3 |
| #108 | Atualizar base de dados com os dados do SIGAA | Eric Wu Harris | 5 |
| #109 | Visualização de formulários para responder | Eric Wu Harris | 2 |
| #104 | Sistema de Login | Felipe Lauterjung Caselli | 5 |
| #112 | Edição e deleção de templates | Felipe Lauterjung Caselli | 3 |
| #113 | Criação de formulário para docentes ou discentes | Felipe Lauterjung Caselli | 5 |

**🚀 Velocity Total Planejado da Sprint 1:** 56 pontos

---

## 📜 Regras de Negócio por Funcionalidade

**#101 - Gerar relatório do administrador**
* O sistema deve permitir a exportação dos dados tabulados em formato CSV.
* Apenas usuários com privilégios de administrador podem acionar a geração de relatórios.
* É vetada a geração de relatórios para formulários que ainda estão com o período de submissão aberto.

**#102 - Criar template de formulário**
* O template necessita obrigatoriamente de um título descritivo e, no mínimo, uma pergunta associada.
* O sistema deve impedir o salvamento de templates vazios (sem questões).
* Restrito ao acesso de administradores.

**#103 - Criar formulário de avaliação**
* O formulário instanciado deve derivar obrigatoriamente de um template previamente cadastrado no banco.
* O administrador é responsável por vincular quais turmas terão acesso ao formulário.
* Acesso exclusivo para administradores.

**#104 - Sistema de Login**
* O acesso deve ser concedido mediante verificação de e-mail ou matrícula junto à senha criptografada.
* Em caso de credenciais inválidas, a interface deve alertar o usuário sem redirecionamento.
* Usuários com a flag de "administrador" devem ter o menu lateral de gerenciamento desbloqueado após a autenticação.

**#105 - Sistema de definição de senha**
* O usuário deve definir a senha inicial através de um link de verificação disparado para seu e-mail cadastrado.
* É obrigatória a validação de igualdade entre os campos "Nova Senha" e "Confirmar Senha".
* As senhas nunca devem ser salvas em texto limpo; o uso de hash de criptografia é obrigatório.

**#106 - Sistema de gerenciamento por departamento**
* O isolamento de dados deve garantir que administradores visualizem e editem apenas as turmas pertencentes ao seu próprio departamento.
* Tentativas de acesso via URL a departamentos terceiros devem ser bloqueadas (Forbidden).

**#107 - Redefinição de senha**
* O fluxo de recuperação exige o envio de um token único e com tempo de expiração via e-mail.
* Tokens expirados devem inviabilizar a troca e solicitar que o usuário gere um novo link.
* Concluída a redefinição, o usuário é levado de volta ao ponto de autenticação (Login).

**#108 - Atualizar base de dados com os dados do SIGAA**
* O processamento deve varrer a base atual e sobrescrever apenas registros que sofreram mutação no SIGAA.
* O sistema deve emitir um feedback visual ao administrador indicando sucesso ou falha da sincronização.

**#109 - Visualização de formulários para responder**
* A interface do discente deve filtrar e exibir estritamente formulários pendentes do semestre vigente.
* Se o usuário não possuir avaliações pendentes, a tela deve exibir um componente de "estado vazio" (*empty state*) comunicando que não há ações necessárias.

**#111 - Visualização dos templates criados**
* A listagem deve ocorrer em uma tabela ou grid exibindo título e a data de elaboração.
* Templates que ainda não foram utilizados em nenhuma avaliação ativa devem ter um indicativo visual específico.

**#112 - Edição e deleção de templates**
* Se um template já estiver associado a um formulário enviado/respondido, a funcionalidade de deleção deve ser desabilitada para preservar o histórico.
* Alterar a estrutura de um template não pode modificar retroativamente formulários que já estão em andamento.

**#113 - Criação de formulário para docentes ou discentes**
* O formulário deve possuir uma flag determinando o público-alvo (docente da disciplina ou alunos matriculados).
* É obrigatória a definição de *timestamps* de abertura e encerramento para aceitação de respostas.

**#98 - Importar dados do SIGAA**
* A funcionalidade processa arquivos de carga em formato JSON contendo o mapeamento de classes, membros e disciplinas.
* Falhas de schema no JSON ou duplicação de dados devem interromper a transação e notificar o erro.

**#99 - Responder formulário**
* O sistema deve assegurar a unicidade de respostas: um usuário submete o formulário apenas uma vez por turma.
* Discentes visualizam apenas formulários atrelados às turmas que constam em seu vínculo.

**#100 - Cadastrar usuários do sistema**
* O provisionamento de contas é derivado diretamente do parse do arquivo JSON do SIGAA (ações manuais são restritas ao admin).
* CPFs/Matrículas devem ser tratados como chave única no banco de dados.

---

## 🔀 Política de Branching

A equipe utilizará a estratégia de ramificação baseada na organização por sprint e divisões individuais. Nenhuma alteração direta deverá ser feita na branch principal.

* **Padrão de nomenclatura das branches:** `bdd-[nome-do-participante]`
  * *Exemplos:* `bdd-felipe`, `bdd-caio`.
* **Fluxo de Integração:** Todos os commits de desenvolvimento devem ser feitos em suas respectivas branches individuais. Ao término das implementações, cada desenvolvedor integrará seu código diretamente na branch unificada `sprint-1`.
* **Pull Request:** Para a entrega, será aberto um Pull Request (PR) no repositório oficial (`EngSwCIC/CAMAAR`), partindo da nossa branch `sprint-1`.
