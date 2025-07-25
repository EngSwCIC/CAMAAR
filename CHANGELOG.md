# Changelog

Todas as mudanças notáveis deste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Adicionado
- Configuração completa de CI/CD com GitHub Actions
- Workflows para testes, linting e análise de segurança
- Templates de PR e Issues
- Dependabot para atualizações automáticas
- Script de CI local (`scripts/ci_local.sh`)
- Badges de status no README
- Documentação completa de CI/CD

### Corrigido
- Suíte de testes RSpec (267 testes, 0 falhas)
- Configuração RuboCop para Rails
- Vulnerabilidades de segurança identificadas pelo Brakeman
- Associações entre modelos
- Enums e validações nos modelos

### Alterado
- Configuração do RuboCop mais permissiva para desenvolvimento
- Estrutura de documentação no README
- Configuração de testes com relatórios JUnit

## [0.1.0] - 2025-01-11

### Adicionado
- Implementação inicial do sistema CAMAAR
- Modelos básicos (User, Template, Formulario, etc.)
- Controllers para todas as entidades
- Views básicas com ERB
- Configuração inicial do Rails 8.0.2
- Integração com Devise para autenticação
- Testes RSpec para models, controllers e views
- Configuração básica do Cucumber para BDD

### Segurança
- Implementação de autenticação com Devise
- Configuração de autorização baseada em roles
- Análise de segurança com Brakeman
