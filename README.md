# CAMAAR

## Integrantes do Grupo
- **CARLOS EDUARDO DE SOUSA ARNAUD** - Matrícula: 221006324
- **Gabriel Roberto de Queiroz** - Matrícula: 221020870
- **Gustavo Vieira de Araújo** - Matrícula: 211068440
- **Luis Antonio Benjamim Flexa** - Matrícula: 221006389
- **Thiago Fernandes Carvalho de Souza** - Matrícula: 221030885

## Nome do Projeto
- **CAMAAR**

## Escopo do Projeto
O projeto CAMAAR envolve o desenvolvimento de uma aplicação web voltada para a avaliação de cursos em uma instituição de ensino superior. A avaliação será filtrada com base no semestre e no professor que ministrou a matéria no período em questão. A avaliação dos cursos será feita com base em formulários criados pelo professor responsável, permitindo uma análise detalhada da qualidade do ensino e da percepção dos alunos.

## Scrum Master e Product Owner
- **Scrum Master**: Thiago Fernandes Carvalho de Souza
- **Product Owner**: Luis Antonio Benjamim Flexa


## Funcionalidades, Regras de Negócio e Estimativas de Pontos

1. **Funcionalidade 1: Atualizar base de dados com os dados do SIGAA**
    - **Regras de Negócio**:
        - Verificar a autenticidade e integridade dos dados importados.
        - Atualizar registros existentes e adicionar novos registros sem duplicação.
        - Garantir a compatibilidade dos dados com os sistemas internos.
    - **Pontos**: 8

2. **Funcionalidade 2: Cadastrar usuários do sistema**
    - **Regras de Negócio**:
        - Validar informações pessoais e acadêmicas dos usuários.
        - Garantir a unicidade de cada usuário no sistema.
        - Assegurar diferentes níveis de acesso conforme o perfil do usuário (aluno, professor, administrador).
    - **Pontos**: 5

3. **Funcionalidade 3: Criar formulário de avaliação**
    - **Regras de Negócio**:
        - Permitir que professores criem formulários personalizados.
        - Oferecer diversos tipos de perguntas (múltipla escolha, dissertativas).
        - Validar a completude e coerência das perguntas antes da publicação.
    - **Pontos**: 8

4. **Funcionalidade 4: Criar template de formulário**
    - **Regras de Negócio**:
        - Fornecer uma interface para criação de templates reutilizáveis.
        - Garantir que templates possam ser modificados e salvos para uso futuro.
        - Permitir a importação e exportação de templates entre diferentes usuários.
    - **Pontos**: 5

5. **Funcionalidade 5: Edição e deleção de templates**
    - **Regras de Negócio**:
        - Assegurar que apenas os criadores ou administradores possam editar ou deletar templates.
        - Manter um histórico de alterações para auditoria.
        - Implementar confirmações de ação para evitar deleção acidental.
    - **Pontos**: 5

6. **Funcionalidade 6: Gerar relatório do administrador**
    - **Regras de Negócio**:
        - Consolidar dados de avaliações em relatórios detalhados.
        - Oferecer filtros por semestre, curso, professor, entre outros.
        - Garantir a confidencialidade e integridade dos dados nos relatórios.
    - **Pontos**: 8

7. **Funcionalidade 7: Importar dados do SIGAA**
    - **Regras de Negócio**:
        - Automatizar a importação de dados com integração ao SIGAA.
        - Validar a compatibilidade dos dados importados com o sistema interno.
        - Prover logs detalhados do processo de importação para auditoria.
    - **Pontos**: 8

8. **Funcionalidade 8: Sistema de redefinição de Senha**
    - **Regras de Negócio**:
        - Implementar um sistema seguro de redefinição de senha via email ou SMS.
        - Verificar a identidade do usuário antes da redefinição.
        - Fornecer mecanismos de recuperação em caso de falha no processo.
    - **Pontos**: 5

9. **Funcionalidade 9: Responder formulário**
    - **Regras de Negócio**:
        - Garantir que apenas usuários autorizados possam responder aos formulários.
        - Validar todas as respostas antes do envio.
        - Assegurar a confidencialidade das respostas dos alunos.
    - **Pontos**: 5

10. **Funcionalidade 10: Sistema de definição de Senha**
    - **Regras de Negócio**:
        - Exigir uma senha forte com critérios definidos (comprimento mínimo, caracteres especiais).
        - Oferecer feedback em tempo real sobre a força da senha.
        - Armazenar senhas de forma segura utilizando hashing.
    - **Pontos**: 3

11. **Funcionalidade 11: Sistema de gerenciamento por departamento**
    - **Regras de Negócio**:
        - Permitir a criação e gerenciamento de departamentos e cursos associados.
        - Restringir o acesso a dados específicos de cada departamento.
        - Oferecer relatórios segmentados por departamento.
    - **Pontos**: 8

12. **Funcionalidade 12: Sistema de Login**
    - **Regras de Negócio**:
        - Implementar autenticação segura com opções de autenticação multifatorial.
        - Monitorar tentativas de login e bloquear acesso após múltiplas tentativas falhadas.
        - Fornecer notificações de login suspeito.
    - **Pontos**: 5

13. **Funcionalidade 13: Visualização de formulários para responder**
    - **Regras de Negócio**:
        - Listar formulários disponíveis para o usuário com base em suas permissões.
        - Permitir a ordenação e filtragem dos formulários por diversos critérios.
        - Mostrar status de conclusão de cada formulário.
    - **Pontos**: 3

14. **Funcionalidade 14: Visualização de resultados dos formulários**
    - **Regras de Negócio**:
        - Consolidar e exibir resultados de forma clara e intuitiva.
        - Oferecer gráficos e estatísticas para análise dos resultados.
        - Proteger a identidade dos respondentes nas visualizações.
    - **Pontos**: 8

15. **Funcionalidade 15: Visualização dos templates criados**
    - **Regras de Negócio**:
        - Permitir a busca e filtragem de templates criados pelo usuário.
        - Oferecer opções de visualização detalhada e edição rápida.
        - Garantir que os templates estejam atualizados e sincronizados com o sistema.
    - **Pontos**: 3

## Responsáveis pelas Funcionalidades
- **Funcionalidade 1: Atualizar base de dados com os dados do SIGAA** - Luis Antonio Benjamim Flexa
- **Funcionalidade 2: Cadastrar usuários do sistema** - Gustavo Vieira de Araújo
- **Funcionalidade 3: Criar formulário de avaliação** - Gabriel Roberto de Queiroz
- **Funcionalidade 4: Criar template de formulário** - Gustavo Vieira de Araújo
- **Funcionalidade 5: Edição e deleção de templates** - Gabriel Roberto de Queiroz
- **Funcionalidade 6: Gerar relatório do administrador** - Gustavo Vieira de Araújo
- **Funcionalidade 7: Importar dados do SIGAA** - Luis Antonio Benjamim Flexa
- **Funcionalidade 8: Sistema de redefinição de Senha** - Carlos Eduardo de Sousa Arnaud
- **Funcionalidade 9: Responder formulário** - Gabriel Roberto de Queiroz
- **Funcionalidade 10: Sistema de definição de Senha** - Thiago Fernandes Carvalho de Souza
- **Funcionalidade 11: Sistema de gerenciamento por departamento** - Carlos Eduardo de Sousa Arnaud
- **Funcionalidade 12: Sistema de Login** - Luis Antonio Benjamim Flexa
- **Funcionalidade 13: Visualização de formulários para responder** - Gabriel Roberto de Queiroz
- **Funcionalidade 14: Visualização de resultados dos formulários** - Thiago Fernandes Carvalho de Souza
- **Funcionalidade 15: Visualização dos templates criados** - Thiago Fernandes Carvalho de Souza

## Política de Branching
- **Política de branching por funcionalidade**: 
Cada funcionalidade será desenvolvida em uma branch específica, nomeada de acordo com a funcionalidade que está sendo implementada. Isso permitirá um desenvolvimento mais organizado, facilitando a integração e a identificação de mudanças. As branches devem ser revisadas e aprovadas antes de serem mescladas na branch principal (main).
