# Setup do ambiente — CAMAAR

## Pré-requisitos

- Ruby 3.4.6
- Google Chrome instalado
- SQLite3

---

## 1. Clonar o repositório

```bash
git clone <url-do-repositorio>
cd CAMAAR
```

---

## 2. Instalar as gems

```bash
bundle install
```

---

## 3. Configurar o banco de dados

```bash
bin/rails db:prepare
bin/rails db:test:prepare
```

---

## 4. Verificar a instalação

```bash
bundle exec cucumber --dry-run
```

Saída esperada (antes de implementar os steps):

```
71 scenarios (71 undefined)
404 steps (404 undefined)
```

Nenhum erro de configuração = ambiente pronto.

---

## Rodando os testes

```bash
# Todos os cenários
bundle exec cucumber

# Um arquivo específico
bundle exec cucumber features/sistema_login.feature

# Um cenário pela linha
bundle exec cucumber features/sistema_login.feature:10

# Por tag
bundle exec cucumber --tags @Issue-9
```

---

## Problemas comuns

**`FATAL: database does not exist`**
```bash
bin/rails db:test:prepare
```

**ChromeDriver incompatível com o Chrome instalado**
```bash
bundle update selenium-webdriver
```
