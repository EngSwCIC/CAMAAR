# 📝 Wiki do Projeto – Sprint 1: Etapa 1

**Grupo 1 – Engenharia de Software**  
**Integrantes:**

| Nome        | Matrícula |
| :---------- | :-------- |
| Caroline    | 232050975 |
| Célio       | 211010350 |
| Luís Filipe | 190091975 |
| Mário       | 231035778 |

# 📌 Nome do Projeto

**CAMAAR – Sistema para avaliação de atividades acadêmicas remotas do CIC**

# 📌 Escopo do Projeto

O sistema **CAMAAR** tem como objetivo auxiliar na avaliação acadêmica de atividades, tarefas e outras atividades remotas do CIC.  
O projeto contempla funcionalidades de cadastro de usuários, redefinição de senha, importação de base de dados do SIGAA, visualização de formulários, criação de formulários, criação de templates para formulários e download de resultados dos relatórios.

# 🔰 Papéis na Sprint 1

● Especificar os cenários BDD das histórias de usuário usando o
Cucumber.   
Responsáveis: Caroline, Célio, Luís Filipe e Mário.  

● Abrir uma Pull Request com as especificações dos testes de aceitação
(BDD) no repositório principal.  
Responsável: Mário  

● Entregar arquivo .txt contendo um link para o repositório, o nome e a
matrícula dos integrantes.  
Responsável: Mário    

● Criar um arquivo Markdown como Wiki, contendo
as informações sobre a Sprint 1.  
Responsáveis: Caroline, Célio, Luís Filipe e Mário.


## 🧑‍💼 Scrum Master

Caroline, Célio, Luís Filipe e Mário.

## 🧑‍💻 Product Owner

Caroline, Célio, Luís Filipe e Mário.

# Quais funcionalidades serão desenvolvidas?

Nesta Sprint 1: 1° Etapa os integrantes irão Especificar os cenários BDD de acordo com as histórias de usuários, cada cenário BDD deve possuir pelo menos um cenário feliz e um triste.
As US desta sprint são:  
[02 - Edição e deleção de templates](https://github.com/mariosantos-05/CAMAAR-G1/issues/2)  
[03 - Visualização dos templates criados](https://github.com/mariosantos-05/CAMAAR-G1/issues/3)  
[04 - Importar dados do SIGAA](https://github.com/mariosantos-05/CAMAAR-G1/issues/4)  
[05 - Responder formulário](https://github.com/mariosantos-05/CAMAAR-G1/issues/5)  
[06 - Cadastrar usuários do sistema](https://github.com/mariosantos-05/CAMAAR-G1/issues/6)  
[07 - Gerar relatório do Administrador](https://github.com/mariosantos-05/CAMAAR-G1/issues/7)  
[08 - Criar template de formulário](https://github.com/mariosantos-05/CAMAAR-G1/issues/8)  
[09 - Criar formulários de avaliação](https://github.com/mariosantos-05/CAMAAR-G1/issues/9)  
[10 - Sistema de login](https://github.com/mariosantos-05/CAMAAR-G1/issues/10)  
[11 - Sistema de definição de senha](https://github.com/mariosantos-05/CAMAAR-G1/issues/11)  
[12 - Sistema de gerenciamento por departamento](https://github.com/mariosantos-05/CAMAAR-G1/issues/12)  
[13 - Redefinição de senha](https://github.com/mariosantos-05/CAMAAR-G1/issues/13)  
[14 - Atualizar base de dados com os dados do SIGAA](https://github.com/mariosantos-05/CAMAAR-G1/issues/14)  
[15 - Visualização de formlários para responder](https://github.com/mariosantos-05/CAMAAR-G1/issues/15)  
[16 - Visualização de Resultado dos Formulários](https://github.com/mariosantos-05/CAMAAR-G1/issues/16)  
[17 - Criação de formulário para docentes ou discentes](https://github.com/mariosantos-05/CAMAAR-G1/issues/17)

# Quais serão as regras de negócio para cada funcionalidade?
## Regras de Negócio - Redefinição de Senha
(Issue 13: "Quero redefinir uma senha... a partir do e-mail recebido...")

| Código     | Descrição                                                                                                           |
|------------|---------------------------------------------------------------------------------------------------------------------|
| RN-RS-01   | O usuário deve informar um e-mail cadastrado para solicitar a redefinição de senha.                                 |
| RN-RS-02   | Caso o e-mail **não exista** no sistema, exibir mensagem de sucesso genérica ("Se este e-mail estiver cadastrado...") para evitar enumeração de usuários. |
| RN-RS-03   | Se o e-mail existir, gerar um **token único** de redefinição e enviá-lo por e-mail ao usuário.                      |
| RN-RS-04   | O token de redefinição deve expirar em **60 minutos**.                                                              |
| RN-RS-05   | O token é de **uso único** – após a redefinição da senha, torna-se inválido.                                        |
| RN-RS-06   | A nova senha deve obedecer às regras de complexidade do sistema (ver RN-DS-02).                                    |

## Regras de Negócio - Definição de Senha (Primeiro Acesso)
(Issue 11: "Quero definir uma senha... a partir do e-mail do sistema de solicitação de cadastro...")

| Código     | Descrição                                                                                                           |
|------------|---------------------------------------------------------------------------------------------------------------------|
| RN-DS-01   | O link de definição de senha é de **uso único**.                                                                    |
| RN-DS-02   | A senha deve ter no mínimo **8 caracteres**, contendo letras maiúsculas, minúsculas e números.                     |
| RN-DS-03   | Os campos **"Nova Senha"** e **"Confirmar Senha"** devem ser idênticos; caso contrário, exibir erro.               |
| RN-DS-04   | A conta só muda de status **"Pendente" → "Ativo"** após a definição bem-sucedida da senha (cadastro efetivado).   |

## Regras de Negócio - Cadastro de Usuários via Importação
(Issue 06: "Quero cadastrar participantes... ao importar dados de usuarios novos...")

| Código     | Descrição                                                                                                           |
|------------|---------------------------------------------------------------------------------------------------------------------|
| RN-C-01    | A funcionalidade de importação só está acessível para usuários com perfil **"Admin"**.                              |
| RN-C-02    | Aceitar **apenas** arquivos no formato **.json**. Qualquer outro formato (ex: .pdf, .csv) → "Formato de arquivo inválido". |
| RN-C-03    | O arquivo deve ser um **JSON válido** (sintaxe correta). Erros de sintaxe → "O arquivo não é um JSON válido".       |
| RN-C-04    | Cada objeto de usuário deve conter **obrigatoriamente** as chaves `"matricula"` e `"email"`. Falta de qualquer uma → rejeitar importação. |
| RN-C-05    | As chaves devem ter tipos corretos (ex: `"matricula"` deve ser número/string numérica válida).                     |
| RN-C-06    | Se a matrícula **não existir** no banco, criar novo usuário com status **"Pendente"**.                              |
| RN-C-07    | **Não** disparar automaticamente o e-mail de definição de senha ao criar usuário "Pendente" via importação.       |
| RN-C-08    | Se a matrícula já existir, **não criar duplicata**.                                                                |
| RN-C-09    | Se a matrícula já existir, **atualizar** os dados do usuário (ex: atualizar e-mail se diferente no JSON).          |

## Regras de Negócio - Sistema de Login
(Issue 10: "Quero acessar o sistema utilizando um e-mail ou matrícula...")

| Código     | Descrição                                                                                                           |
|------------|---------------------------------------------------------------------------------------------------------------------|
| RN-L-01    | O usuário deve poder se autenticar usando **e-mail** ou **número de matrícula** no mesmo campo de login.            |
| RN-L-02    | Os campos **"E-mail ou Matrícula"** e **"Senha"** são de preenchimento obrigatório.                                  |
| RN-L-03    | Em caso de e-mail/matrícula ou senha incorretos, exibir mensagem genérica **"E-mail ou senha inválidos"** (nunca informar qual dos dois está errado). |
| RN-L-04    | Usuários com perfil **"Admin"** devem ter a opção **"Gerenciamento"** exibida no menu lateral.                      |
| RN-L-05    | Usuários com perfil diferente de "Admin" (ex: Aluno, Professor) **não devem** ver a opção "Gerenciamento".         |
| RN-L-06    | O login só é permitido se o status da conta do usuário for **"Ativo"** (ou seja, após a primeira definição de senha). |

## Regras de Negócio - Criar Formulário (Template de Questões)
(Issue 09: "Quero criar um template de formulário contendo as questões do formulário...")

| Código     | Descrição                                                                                          |
|------------|----------------------------------------------------------------------------------------------------|
| RN-CF-01   | **Confirmação de Exclusão**: A ação de deletar um template exige confirmação explícita (pop-up) antes de ser executada. |
| RN-CF-02   | **Tipos de Questões**: O sistema deve permitir incluir e persistir diferentes tipos de perguntas (múltipla escolha, discursiva, etc.) no mesmo template. |

## Regras de Negócio - Criar Template de Formulário
(Issue 17: "Quero escolher criar um formulário para os docentes ou os discentes...")

| Código    | Descrição                                                                                          |
|-----------|----------------------------------------------------------------------------------------------------|
| RN-CTF-01 | **Obrigatoriedade de Título**: Não é permitido criar ou salvar um template com o campo "Nome/Título" vazio. |
| RN-CTF-02 | **Imutabilidade Histórica**: A edição de um template **não pode** alterar a estrutura ou os dados de formulários já respondidos (instâncias antigas permanecem inalteradas). |

## Regras de Negócio - Visualizar Templates
(Issue 03: "Quero visualizar os templates criados")

| Código    | Descrição                                                                                          |
|-----------|----------------------------------------------------------------------------------------------------|
| RN-VT-01   | **Condicionalidade de Campos**: O campo "Turma" deve ser **obrigatório** quando o público-alvo for "Discentes" e **oculto** quando for "Docentes". |
| RN-VT-02   | **Segmentação de Envio**: O formulário gerado deve ser enviado **apenas** para os usuários vinculados à turma selecionada. |

## Regras de Negócio - Editar e Deletar Template
(Issue 02: "Quero editar e/ou deletar um template que eu criei sem afetar...")

| Código    | Descrição                                                                                          |
|-----------|----------------------------------------------------------------------------------------------------|
| RN-ET-01  | **Estado de Lista Vazia**: Quando não houver templates cadastrados, exibir a mensagem "Nenhum template foi criado" em vez de uma lista em branco. |
| RN-ET-02  | **Ações de Gerenciamento**: Cada item da lista deve exibir botões individuais de **"Editar"** e **"Deletar"**. |

## Regras de Negócio - Importação de Dados do SIGAA (Apenas Adicionar)
(Issue 04: Importar dados do SIGAA)
(Quero importar dados de turmas, matérias e participantes do SIGAA caso não existam na base de dados atual)

| Código    | Descrição                                                                                                           |
|-----------|---------------------------------------------------------------------------------------------------------------------|
| RN-IDS-13 | Para cada item do JSON, verificar a chave única (ex: matrícula do aluno ou código da disciplina):<br>• Se **não existir** → criar o registro.<br>• Se **já existir** → ignorar o item (não atualizar nem duplicar). |
| RN-IDS-14 | Esta é uma operação de **"apenas adicionar"**, usada para alimentar a base sem risco de sobrescrever dados já alterados manualmente. |
| RN-IDS-15 | Aceitar somente arquivos com extensão **.json**. Qualquer outro formato deve ser rejeitado com mensagem de erro.   |
| RN-IDS-16 | O arquivo .json deve ser sintaticamente válido. Erro de sintaxe → rejeição imediata com mensagem de erro clara. |

## Regras de Negócio - Gerenciamento de Relatórios e Resultados
(Issue 07: Gerar relatório do administrador – Quero baixar um arquivo CSV contendo os resultados de um formulário)

| Código    | Descrição                                                                                                           |
|-----------|---------------------------------------------------------------------------------------------------------------------|
| RN-GR-01  | O acesso à página **"Gerenciamento → Resultados"** e todas as suas funcionalidades é restrito exclusivamente a usuários com papel **"Administrador"**. |
| RN-GR-02  | Usuários sem perfil Administrador **não devem ver** o link da página. Caso tentem acessar diretamente a URL, devem ser bloqueados e redirecionados ao seu dashboard. |
| RN-GR-03  | Ao solicitar o download dos resultados, o sistema deve gerar e oferecer um arquivo no formato **CSV**.              |

## Regras de Negócio - Atualizar Dados Existentes (via SIGAA)
(Issue 14: Quero atualizar a base de dados já existente com os dados atuais do SIGAA)

| Código    | Descrição                                                                                                           |
|-----------|---------------------------------------------------------------------------------------------------------------------|
| RN-ADE-01 | Se o item (aluno, turma, etc.) do JSON **não existir** no banco, o sistema deve criá-lo.                              |
| RN-ADE-02 | Se o item do JSON **já existir** no banco, o sistema deve atualizar o registro existente com os dados do JSON.     |
| RN-ADE-03 | O sistema **nunca** deve criar duplicatas – a ação é sempre de correção/atualização do registro existente.          |
| RN-ADE-04 | Aceitar apenas arquivos com extensão **.json**. Qualquer outro formato deve ser rejeitado.                         |
| RN-ADE-05 | O arquivo .json deve ser sintaticamente válido. Caso contrário, a importação deve ser rejeitada.                   |
| RN-ADE-06 | O JSON deve conter todas as chaves obrigatórias esperadas. Se algum item estiver sem chave obrigatória (ex: matrícula), a importação deve falhar. |
| RN-ADE-07 | Após importação bem-sucedida, exibir mensagem de sucesso clara ao administrador.                                   |
| RN-ADE-08 | Após falha na importação (qualquer motivo), exibir mensagem de erro detalhando o problema.                          |

## Regras de Negócio - Gerenciamento de Turmas por Departamento
(Issue 12: Quero gerenciar somente as turmas do departamento o qual eu pertenço)

| Código    | Descrição                                                                                                           |
|-----------|---------------------------------------------------------------------------------------------------------------------|
| RN-GTD-01 | Se um usuário (administrador de departamento ou não) tentar acessar diretamente via URL os dados de turmas de outro departamento, o sistema deve redirecioná-lo imediatamente para sua página principal (Dashboard). |

## Regras de Negócio - Criar Formulário de Avaliação
(Issue 09: "Criar um formulário de avaliação baseado em um template para turmas selecionadas")

| Código | Descrição |
|--------|-----------|
| RN-CFA-01 | **Seleção Obrigatória de Turmas**: Não é permitido criar formulários se nenhuma turma for selecionada; o sistema deve exibir a mensagem de erro "Nenhuma turma selecionada." |
| RN-CFA-02 | **Seleção Obrigatória de Template**: O sistema deve impedir a criação de formulários caso nenhum template seja selecionado, exibindo a mensagem "Nenhum template selecionado." |
| RN-CFA-03 | **Criação em Lote por Turma**: O sistema deve gerar individualmente um formulário para cada turma selecionada quando solicitado. |
| RN-CFA-04 | **Confirmação de Sucesso**: Após criar os formulários, o sistema deve exibir a mensagem "Formulários criados com sucesso para as turmas selecionadas." |

## Regras de Negócio - Responder Formulário
(Issue 05: "Responder o formulário de avaliação como Participante")

| Código | Descrição |
|--------|-----------|
| RN-RF-01 | **Disponibilidade Vinculada à Turma**: O participante só pode responder formulários das turmas em que está matriculado. |
| RN-RF-02 | **Existência de Formulário Ativo**: O sistema só permite acesso e envio se houver um formulário ativo disponível para a turma. |
| RN-RF-03 | **Validação de Campos Obrigatórios**: O sistema deve impedir o envio caso campos obrigatórios não sejam preenchidos, exibindo erro. |
| RN-RF-04 | **Registro de Respostas**: O sistema deve registrar todas as respostas submetidas pelo participante. |
| RN-RF-05 | **Confirmação de Envio**: Após envio bem-sucedido, o sistema deve exibir "Seu formulário foi enviado com sucesso." |

## Regras de Negócio - Visualização de Formulários Pendentes
(Issue 15: "Visualizar os formulários não respondidos das turmas em que o participante está matriculado")

| Código | Descrição |
|--------|-----------|
| RN-VFP-01 | **Exibição Apenas do que Não foi Respondido**: O sistema deve listar somente formulários pendentes. |
| RN-VFP-01 | **Segmentação por Turma Matriculada**: O participante só visualiza formulários das turmas nas quais está matriculado. |
| RN-VFP-01 | **Contador de Formulários Pendentes**: O sistema deve exibir o total de formulários pendentes com mensagem informativa. |
| RN-VFP-01 | **Estado de Lista Vazia**: Na ausência de formulários pendentes, exibir "Você não possui formulários pendentes." |

## Regras de Negócio - Visualizar Resultados dos Formulários
(Issue 16: "Visualização dos formulários criados pelo Administrador")

| Código | Descrição |
|--------|-----------|
| RN-VRF-01 | **Lista de Formulários Criados**: O administrador deve visualizar os formulários criados organizados por turma. |
| RN-VRF-02 | **Contador de Formulários Criados**: O sistema deve exibir o total de formulários criados, como "Existem X formulários criados." |
| RN-VRF-03 | **Acesso aos Detalhes**: O administrador deve poder visualizar perguntas, respostas e estatísticas de cada formulário selecionado. |

## Quem ficou responsável por cada cenário BDD em relação as US/Issues?

#[02](https://github.com/mariosantos-05/CAMAAR-G1/issues/2) Luís Filipe  
#[03](https://github.com/mariosantos-05/CAMAAR-G1/issues/3) Luís Filipe  
#[04](https://github.com/mariosantos-05/CAMAAR-G1/issues/4) Caroline  
#[05](https://github.com/mariosantos-05/CAMAAR-G1/issues/5) Mário  
#[06](https://github.com/mariosantos-05/CAMAAR-G1/issues/6) Célio  
#[07](https://github.com/mariosantos-05/CAMAAR-G1/issues/7) Caroline  
#[08](https://github.com/mariosantos-05/CAMAAR-G1/issues/8) Luís Filipe  
#[09](https://github.com/mariosantos-05/CAMAAR-G1/issues/9) Mário  
#[10](https://github.com/mariosantos-05/CAMAAR-G1/issues/10) Célio  
#[11](https://github.com/mariosantos-05/CAMAAR-G1/issues/11) Célio  
#[12](https://github.com/mariosantos-05/CAMAAR-G1/issues/12) (Caroline ou Luís Filipe)  
#[13](https://github.com/mariosantos-05/CAMAAR-G1/issues/13) Célio  
#[14](https://github.com/mariosantos-05/CAMAAR-G1/issues/14) Caroline  
#[15](https://github.com/mariosantos-05/CAMAAR-G1/issues/15) Mário  
#[16](https://github.com/mariosantos-05/CAMAAR-G1/issues/16) Mário  
#[17](https://github.com/mariosantos-05/CAMAAR-G1/issues/17) (Caroline ou Luís Filipe)

---

# 📊 Métrica Velocity da Sprint 1

| História/Issue   | Pontos              |
| ---------------- | ------------------- |
| US / #02         | 2                   |
| US / #03         | 1                   |
| US / #04         | 3                   |
| US / #05         | 2                   |
| US / #06         | 3                   |
| US / #07         | 2                   |
| US / #08         | 3                   |
| US / #09         | 3                   |
| US / #10         | 2                   |
| US / #11         | 2                   |
| US / #12         | 3                   |
| US / #13         | 3                   |
| US / #14         | 3                   |
| US / #15         | 2                   |
| US / #16         | 3                   |
| US / #17         | 3                   |
| **Total**        | **Story Points**    |
| **16 US/Issues** | **40 Story Points** |

---

# 🌿 Política de Branching Utilizada pelo Grupo

Sprint Branching + Feature Branching (variação do GitLab Flow):

- A equipe cria uma branch representando a sprint a partir da main.

- Todas as feature branches da sprint nascem a partir dela.

- No final da sprint, tudo é consolidado e mergeado para a branch da sprint.
