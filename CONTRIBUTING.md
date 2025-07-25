# Guia de Contribuição

Obrigado pelo seu interesse em contribuir para o projeto CAMAAR! Este guia fornece informações sobre como contribuir efetivamente.

## Configuração do Ambiente

### Pré-requisitos
- Ruby 3.2.0
- Rails 8.0.2
- SQLite3
- Git

### Configuração Inicial
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/CAMAAR-Projeto-Engenharia-de-Software.git
cd CAMAAR-Projeto-Engenharia-de-Software

# Instale as dependências
bundle install

# Configure o banco de dados
rails db:create db:migrate db:seed

# Execute os testes
bundle exec rspec
```

## Fluxo de Contribuição

### 1. Criação de Branch
```bash
# Crie uma branch a partir da develop
git checkout develop
git pull origin develop
git checkout -b feature/CAMAAR-123-nova-funcionalidade
```

### 2. Desenvolvimento
- Implemente sua funcionalidade
- Escreva testes para seu código
- Mantenha o código limpo e bem documentado

### 3. Testes
```bash
# Execute todos os testes
bundle exec rspec

# Execute o linter
bundle exec rubocop

# Execute análise de segurança
bundle exec brakeman

# Ou execute tudo de uma vez
./scripts/ci_local.sh
```

### 4. Commit
```bash
# Adicione suas mudanças
git add .

# Faça commit seguindo o padrão
git commit -m "feat(auth): implementa autenticação com JWT

- Adiciona middleware de autenticação
- Implementa geração de tokens
- Adiciona testes unitários

Closes #123"
```

### 5. Push e Pull Request
```bash
# Push da branch
git push origin feature/CAMAAR-123-nova-funcionalidade

# Crie um Pull Request no GitHub
```

## Padrões de Código

### Commits
Seguimos o padrão [Conventional Commits](https://www.conventionalcommits.org/):

```
tipo(escopo): descrição breve

Descrição mais detalhada se necessário

Closes #123
```

**Tipos de commit:**
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Tarefas de manutenção

### Código Ruby
- Seguimos o guia de estilo do RuboCop
- Mantenha métodos com no máximo 15 linhas
- Use nomes descritivos para variáveis e métodos
- Escreva testes para todo código novo

### Testes
- Escreva testes para models, controllers e views
- Mantenha cobertura de testes alta
- Use factories ao invés de fixtures
- Testes devem ser independentes

## Estrutura do Projeto

```
app/
├── controllers/    # Lógica de controle
├── models/        # Modelos de dados
├── views/         # Templates ERB
└── helpers/       # Métodos auxiliares

spec/
├── models/        # Testes de modelos
├── controllers/   # Testes de controllers
├── views/         # Testes de views
└── requests/      # Testes de integração
```

## CI/CD

### GitHub Actions
- Testes executam automaticamente em PRs
- RuboCop verifica estilo de código
- Brakeman analisa vulnerabilidades
- Artefatos são salvos para análise

### Qualidade
- Todos os testes devem passar
- RuboCop não deve ter violações
- Brakeman não deve ter problemas críticos

## Revisão de Código

### Checklist para Reviewers
- [ ] Código está limpo e bem documentado
- [ ] Testes cobrem a funcionalidade
- [ ] Não há problemas de segurança
- [ ] Performance está adequada
- [ ] Funcionalidade atende aos requisitos

### Processo
1. Pelo menos 2 reviewers devem aprovar
2. Todos os checks de CI devem passar
3. Conflitos devem ser resolvidos
4. Merge para develop após aprovação

## Problemas e Sugestões

### Reportar Bugs
Use o template de bug report no GitHub Issues:
- Descreva o problema claramente
- Inclua passos para reproduzir
- Adicione screenshots se aplicável
- Especifique versões do sistema

### Sugerir Funcionalidades
Use o template de feature request:
- Descreva a funcionalidade desejada
- Explique o problema que resolve
- Inclua critérios de aceitação
- Considere alternativas

## Contato

Para dúvidas sobre contribuição, entre em contato com a equipe através das issues do GitHub ou pelos canais do projeto.

---

Obrigado por contribuir para o CAMAAR! 🎓
