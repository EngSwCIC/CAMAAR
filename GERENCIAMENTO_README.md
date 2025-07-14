# Funcionalidade de Gerenciamento e Importação de Dados

## Visão Geral

A nova funcionalidade de **Gerenciamento** permite que administradores importem dados do SIGAA e controlem o acesso às demais funcionalidades do sistema.

## Acesso

- **Quem pode acessar**: Apenas usuários com role `admin`
- **Como acessar**: Menu lateral → "Gerenciamento" ou URL `/admin/management`

## Funcionalidades

### 1. Importação de Dados

#### Importar Usuários
- **Arquivo**: `class_members.json` (dados dos usuários do SIGAA)
- **Formato esperado**: 
  ```json
  [
    {
      "code": "CIC0097",
      "classCode": "TA", 
      "semester": "2021.2",
      "dicente": [...],
      "docente": {...}
    }
  ]
  ```
- **Campos importados**: nome, email, matrícula, curso, departamento, formação, ocupação
- **Roles atribuídos**: docente → professor, dicente → aluno

#### Importar Disciplinas
- **Arquivo**: `classes.json` (dados das disciplinas)
- **Formato esperado**:
  ```json
  [
    {
      "code": "CIC0097",
      "name": "BANCOS DE DADOS",
      "class": {
        "classCode": "TA",
        "semester": "2021.2", 
        "time": "35T45"
      }
    }
  ]
  ```
- **Campos importados**: código, nome, código da turma, semestre, horário
- **Cursos criados**: Baseado no prefixo do código (CIC → Ciência da Computação)

### 2. Controle de Acesso

As seguintes funcionalidades ficam **bloqueadas** até que dados sejam importados:
- ✅ **Editar Templates**
- ✅ **Enviar Formulários** 
- ✅ **Resultados**

### 3. Estatísticas

Após importação, são exibidas:
- Total de usuários no sistema
- Total de disciplinas cadastradas
- Total de cursos disponíveis

## Novos Campos no Banco de Dados

### Tabela `users`
- `curso` (string): Curso do usuário
- `departamento` (string): Departamento (para docentes)
- `formacao` (string): Nível de formação

### Tabela `disciplinas`
- `codigo` (string): Código da disciplina (ex: CIC0097)
- `codigo_turma` (string): Código da turma (ex: TA, TB)
- `semestre` (string): Semestre (ex: 2021.2)
- `horario` (string): Horário das aulas (ex: 35T45)

## Fluxo de Uso

1. **Admin acessa o sistema** → Redirecionado para Gerenciamento
2. **Clica em "Importar Dados"** → Abre modal com opções
3. **Seleciona arquivo JSON** → Faz upload
4. **Sistema processa** → Exibe resultado da importação
5. **Dados importados** → Funcionalidades são liberadas
6. **Acesso às demais telas** → Sistema totalmente funcional

## Arquivos de Teste

Foram criados arquivos de exemplo para testar:
- `test_users.json` - Usuários de exemplo
- `test_disciplines.json` - Disciplinas de exemplo

## Segurança

- ✅ Apenas admins podem acessar
- ✅ Validação de arquivos JSON
- ✅ Tratamento de erros
- ✅ Logs de importação
- ✅ Senha padrão para usuários importados: `123456`

## Interface

- Design responsivo
- Cards com indicadores visuais
- Modais para importação
- Feedback em tempo real
- Estatísticas pós-importação
