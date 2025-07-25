# 🧪 Guia de Testes - Sistema de Gerenciamento de Usuários

## ❗ IMPORTANTE: Sempre use `bundle exec`

**NUNCA execute `rspec` diretamente!** Sempre use `bundle exec rspec` para evitar conflitos de versão de gems.

## ✅ Comandos Corretos para Executar os Testes

### 1. Testes do Modelo User (26 testes)
```bash
bundle exec rspec spec/models/user_spec.rb --format documentation
```

### 2. Testes de Integração do Sistema (6 testes)
```bash
bundle exec rspec spec/integration/user_management_system_spec.rb --format documentation
```

### 3. Todos os Testes do Sistema de Usuários (32 testes)
```bash
bundle exec rspec spec/models/user_spec.rb spec/integration/user_management_system_spec.rb --format documentation
```

### 4. Execução Rápida com Progresso
```bash
bundle exec rspec spec/models/user_spec.rb spec/integration/user_management_system_spec.rb --format progress
```

## 🎯 O que os Testes Cobrem

### 📝 **Modelo User (26 testes):**
- ✅ Validações (nome, email, matrícula, role, curso)
- ✅ Enums e identificação de roles 
- ✅ Associações com outras entidades
- ✅ Callbacks (email em minúsculas)
- ✅ Sistema de autorização
- ✅ Gerenciamento de disciplinas por tipo de usuário

### 🔗 **Integração do Sistema (6 testes):**
- ✅ Criação de diferentes tipos de usuários
- ✅ Validação de dados
- ✅ Gerenciamento de atribuição de curso
- ✅ Associações de disciplinas
- ✅ Controle de autorização

## 🚫 Erros Comuns e Soluções

### Erro: "You have already activated erb 5.0.2, but your Gemfile requires erb 5.0.1"
**Solução:** Sempre use `bundle exec rspec` em vez de apenas `rspec`

### Erro: "Factory already registered"
**Solução:** Remova arquivos duplicados de configuração do FactoryBot

### Erro: "database is locked"
**Solução:** Pare o servidor Rails e execute `rails db:test:prepare`

## 📊 Resultado Esperado

Quando tudo está funcionando corretamente, você deve ver:

```
User Management System Integration
  User model functionality
    creates different types of users
    validates user data
    manages user course assignment
  Discipline associations
    associates professor with disciplines
    associates student with disciplines through matriculas
  Authorization system
    allows only admins to register new users

Finished in X.XX seconds
32 examples, 0 failures
```

## 🎉 Status Atual

✅ **32 testes passando, 0 falhas**  
✅ **Sistema de gerenciamento de usuários funcionando perfeitamente**  
✅ **Todas as funcionalidades implementadas e testadas**
