## Integrantes

- Jônatas Gonçalves Pereira Râmos Côrtes - 241031683
- José Artur Nordestino Aguiar de Oliveira - 180020439
- Davi César Silva Borges - 190105054
- Victória Silva da Rocha - 200062875

# CAMAAR

Sistema para avaliação de atividades acadêmicas remotas do CIC

## Sprint 1

Sprint com objetivo de definir os requisitos técnicos e funcionais do projeto:
1. Especificar os cenários **BDD** das **histórias de usuário**.
2. Gerar um **MER** (Modelo Entidade Relacionamento) para a camada de persistência.
3. Fazer uma investigação técnica acerca da implementação das **views** do projeto.
4. Adicionar um arquivo **Markdown** contendo as informações sobre a sprint 1.
5. Definir quais funcionalidades serão desenvolvidas, suas respectivas regras de negócio, quem será o responsável por cada uma e a pontuação a ser atribuida.
6. Definir a **_política de branching_** a ser utilizada pelo grupo.

### Primeira Etapa
Para a primeira etapa é necessário abordar os ítens 1, 4, 5, 6 descritos em #sprint-1

Quanto aos cenários BDD, utilizaremos a ferramenta `Cumcumber` e arquivos com extensão `.feature` para relatar os **Happy Paths** e **Sad Paths** referentes a cada uma das histórias de usuário.

Quanto ao arquivo Markdown, este, em um primeiro momento, dissertará acerca das etapas do desenvolvimento da Sprint 1.

Para os papéis de Scrum Master e Product Owner foram designados os membros **José Artur** e **Jônatas Gonçalves** respectivamente.

As funcionalidades a serem desenvolvidas ao longo das próximas sprints serão descritas a seguir.

---

### Importar dados do SIGAA (8 Pontos)

**Responsável:** Jônatas Gonçalves Pereira Râmos Côrtes - 241031683

**Descrição:** Importar turmas, matérias e participantes a partir dos JSONs do repositório.

**Critério / Regras de negócio:**
- Deve existir campo “Insira Código da Disciplina” na tela do administrador.
- Ao inserir código e clicar em “Pesquisar”, exibir as Turmas da disciplina retornadas pelo JSON.
- Em cada turma exibida, deve haver um botão “Adicionar”.
- Ao clicar em "Adicionar", a turma deve ser persistida na base de dados.
- Se a turma já existir, exibir aviso “A turma já está no banco de dados”.
- Em caso de erro no JSON ou falha, exibir mensagem de erro e não persistir dados.

---

### Visualização de formulários para responder (3 Pontos)

**Responsável:** Davi César Silva Borges - 190105054

**Descrição:** Tela do participante (Aluno) mostrando formulários não respondidos das turmas em que está matriculado.

**Regras de negócio:**
- Na tela do Aluno deve-se listar apenas os “Formulários não respondidos” do aluno.
- Em cada formulário listado deve haver um botão “Responder Formulário”.
- Ao clicar em “Responder Formulário” o usuário é levado para a “Tela de Formulário”.
- Se não houver formulários, exibir texto "Não há formulários disponíveis".

---

### Visualização dos templates criados (5 Pontos)

**Responsável:** Victória Silva da Rocha - 200062875

**Descrição:** Administração — visualizar templates de formulário já criados, com opções de editar e deletar.

**Regras de negócio:**
- Na tela do Administrador exibir todos os Templates existentes.
- Em cada template deve haver botão “Editar” e botão “Deletar”.
- Ao clicar em “Editar”, abrir a tela/modal do template com campos preenchidos para modificação.
- Ao clicar em “Deletar”, exibir caixa de confirmação com texto “Tem certeza que deseja deletar?”, botões “Sim” e “Não”.
- Se o usuário clicar em “Não” na confirmação, retornar para a tela de administrador e manter o template.

---

### Criar template de formulário (5 Pontos)

**Responsável:** Jônatas Gonçalves Pereira Râmos Côrtes - 241031683

**Descrição:** Fluxo para criação de um novo template de formulário via interface administrativa.

**Regras de negócio:**
- Na tela de administrador existir menu lateral com opção de gerenciamento.
- No gerenciamento: botão “Editar Templates” que leva para lista de templates e botão de criação de novo template.
- A criação abre um modal com opções de personalização (nome, descrição, tipo de questão, obrigatoriedade, etc).
- Se todas as opções forem preenchidas corretamente, ao clicar em criar, o novo template aparece na lista.
- Se o nome do template não for preenchido, exibir mensagem “o nome é um campo de preenchimento obrigatório”.

---

### Criar formulário de avaliação (5 Pontos)

**Responsável:** Victória Silva da Rocha - 200062875

**Descrição:** Criar um formulário baseado em um template e atribuí-lo a uma ou mais turmas.

**Regras de negócio:**
- Na tela de administrador, via Gerenciamento → Criar Formulário, exibir modal para escolher turmas e template.
- O modal deve listar turmas válidas (existentes) e templates disponíveis.
- Ao concluir e clicar em criar, o formulário deve aparecer na lista de formulários criados.
- (Sad Path restante a ser detalhado se necessário — ex.: erro sem turmas selecionadas, template inválido).

---

### Cadastrar usuário do sistema (8 Pontos)

**Responsável:** José Artur Nordestino Aguiar de Oliveira - 180020439

**Descrição:** Ao importar dados do SIGAA, identificar usuários novos e cadastrá-los no CAMAAR.

**Regras de negócio:**
- Ao importar dados de uma turma, o sistema identifica usuários (docentes e discentes) não existentes no banco.
- Criar um novo registro para cada usuário inexistente com status “pendente”.
- Salvar dados básicos: e-mail, matrícula e nome.
- Enviar automaticamente e-mail solicitando definição de senha inicial.
- Exibir mensagem confirmando importação e cadastro dos novos usuários.
- Se encontrar usuário já cadastrado (e-mail existente), não criar novo registro, não enviar e-mail e exibir aviso “X usuários já estavam cadastrados e foram ignorados”.
- Em caso de falha de importação (comunicação/JSON inválido), não criar/alterar nenhum usuário e exibir erro.

---

### Sistema de login (3 Pontos)

**Responsável:** Victória Silva da Rocha - 200062875

**Descrição:** Autenticação por e-mail ou matrícula e senha para acesso ao sistema.

**Regras de negócio:**
- Na tela de login: campos para email/matrícula e senha.
- Ao fornecer credenciais válidas, redirecionar para a tela de Avaliações.
- Se usuário for Administrador, exibir no menu lateral seção de gerenciamento; caso contrário, exibir apenas avaliações.
- Se credencial inválida (senha incompatível), exibir mensagem "usuário ou senha estão incorretos".

---

### Visualização de resultados dos formulários (5 Pontos)

**Responsável:** Davi César Silva Borges - 190105054

**Descrição:** Administrador visualiza formulários criados e acessa visualização das respostas submetidas.

**Regras de negócio:**
- Na tela de Gerenciamento listar todos os formulários criados.
- Em cada formulário deve haver opção “Visualizar respostas”.
- Ao clicar, direcionar para página que contenha todas as respostas de todos os usuários (para visualização).
- Se não houver respostas submetidas, exibir mensagem informando ausência de respostas.

---

### Gerar relatório do administrador (5 Pontos)

**Responsável:** Victória Silva da Rocha - 200062875

**Descrição:** Gerar e baixar CSV contendo resultados de um formulário (incluindo gráficos).

**Regras de negócio:**
- Na listagem de formulários em Gerenciamento, opção “Gerar relatório”.
- Ao clicar, iniciar download de arquivo CSV com resultados do formulário (e gráficos gerados).
- Se não houver respostas submetidas, exibir mensagem impedindo geração por falta de dados.

---

### Responder formulário (5 Pontos)

**Responsável:** Jônatas Gonçalves Pereira Râmos Côrtes - 241031683

**Descrição:** Permitir que o participante da turma visualize o formulário, responda todas as perguntas e envie suas respostas, garantindo retorno adequado em caso de sucesso ou sessão expirada.

**Regras de negócio:**
- Ao acessar a tela do formulário, o usuário deve visualizar todas as perguntas disponíveis.
- O usuário deve conseguir preencher todas as respostas necessárias antes do envio.
- Ao clicar em "Enviar resposta", caso tudo esteja correto, o sistema deve registrar as respostas e exibir a mensagem "Resposta enviada com sucesso."
- Se a sessão do usuário estiver expirada no momento do envio, o sistema não deve registrar as respostas e deve exibir a mensagem "Sua sessão expirou, faça login novamente."
- Não permitir envio parcial ou com perguntas obrigatórias em branco.

---

### Sistema de definição de senha (4 Pontos)

**Responsável:** José Artur Nordestino Aguiar de Oliveira - 180020439

**Descrição:** Fluxo para usuário definir senha inicial a partir do link recebido por e-mail (após importação).

**Regras de negócio:**
- Background: usuário importado tem status "pendente" e recebeu link válido.
- Se o link for válido e dentro do prazo: usuário informa nova senha que atende requisitos, confirma e a senha é registrada; status do usuário atualizado para "ativo"; redirecionar para página de login.
- Se o link estiver expirado: exibir mensagem que o link expirou e orientar a solicitar novo link.
- Se a senha não atender critérios mínimos: exibir mensagem explicativa e não salvar a senha.
- Se o usuário já tiver status "ativo": impedir criação inicial e sugerir uso do fluxo "esqueci minha senha".
- A senha deve conter ao menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial.
- A senha deve conter ao menos 8 caracteres.

---

### Edição e exclusão de templates sem afetar formulários existentes (3 Pontos)

**Responsável:** José Artur Nordestino Aguiar de Oliveira - 180020439

**Descrição:** Editar/deletar templates de forma que formulários já criados com aquele template não sejam alterados.

**Regras de negócio:**
- Ao editar um template, as alterações afetam somente o template (templates derivados), não os formulários já criados.
- Ao deletar um template, exibir confirmação (“Tem certeza...”) com opções “Sim” e “Não”.
- Se confirmar exclusão, remover o template da lista; nenhum formulário previamente criado que usou o template deve ser alterado.
- Se o administrador cancelar (clicar “Não”), retornar e manter o template.

---

### Sincronizar base de dados com o SIGAA (8 Pontos)

**Responsável:** Davi César Silva Borges - 190105054

**Descrição:** Atualizar dados já existentes na base local com informações mais recentes do SIGAA.

**Regras de negócio:**
- Ao iniciar atualização, identificar usuários do SIGAA que já existem na base interna.
- Atualizar apenas campos permitidos (nome, matrícula, vínculo).
- Registrar em log quais usuários foram atualizados e quais campos foram modificados.
- Ao final, exibir mensagem de atualização concluída.
- Se receber dados inconsistentes/inválidos do SIGAA, cancelar a atualização, não salvar alterações e exibir erro sugerindo tentar novamente mais tarde.
- Se ocorrer falha de comunicação com SIGAA, interromper operação, não alterar dados e exibir mensagem de erro orientando a verificar conexão.

---

### Reset de senha a partir do link recebido por email (1 Ponto)

**Responsável:** Victória Silva da Rocha - 200062875

**Descrição:** Fluxo de redefinição de senha via link recebido no e-mail (forgot password).

**Regras de negócio:**
- Se o link for válido e não expirado: usuário informa nova senha válida, confirma, confirma salvar — então senha é salva, status do usuário atualizado para "ativo" se pendente, redirecionar para login e exibir sucesso.
- Se link expirado: bloquear redefinição, exibir mensagem e oferecer opção de solicitar novo link.
- Se senha não atender aos requisitos mínimos: impedir reset e exibir mensagem explicativa.
- Se confirmação de senha diferente: impedir salvamento e exibir mensagem indicando que as senhas não coincidem.

---

## Política de Branching (recapitulada)

- Branch principal: `main` (estável)
- Branch de integração: Nomeada conforme a sprint
- Branch por funcionalidade: Nomeada conforme a funcionalidade
- Fluxo: criar novas branchs partir da branch da respectiva sprint, desenvolver funcionalidades, fazer Pull Requests, e ao final da sprint realizar o Merge entre a branch da sprint e a main. 

---
