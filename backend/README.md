# Projeto do CAMAAR

## Back-end do projeto CAMAAR feito com Ruby on Rails ♦️

## Dependências
- Ruby 2.7.5
- Rails 7.0.2.3
- Bundler version 1.17.3
- gem 3.1.16
- SQLite 3.8.0
## Desenvolvimento
### ⚙️ Como Executar o Projeto

Primeiramente devemos instalar todas as depedencias:

```
bundle install
```
Após fazer o bundle install é necessario gerar uma chave para o jwt:

```
rake secret
```

Com a chave gerado precisamos adicioná-la no credentials
```
EDITOR=nano rails credentials:edit
```
> substitua o editor nano pelo que você preferir.

Adicione as seguintes linha no Arquivo

```
devise:
  JWT_SECRET_KEY: <secret-gerado>
```

Após isso basta iniciar a aplicação

```
rails server
```
O back-end ficará acessível na porta 3030. 

### Rotas do back-end

Estão disponíveis as seguintes rotas:
- /auth/login
- /auth/logout
- /auth/register
- /users/session
- /users/registrations

### Autenticação

A autenticação da API é feita com JWT( utilizando o devise como helper ).
Para acessar endpoints protegidos basta passar um token valido no header `Authorization`.
A estrutura do header com token seria a seguinte:
```
Authorization: Bearer <Token-Valido>
```

As rotas do back-end podem receber requisições https através do navegador ou 
de ferramentas como:
- [Postman](https://insomnia.rest/)
- [Insomina](https://insomnia.rest/download)
  
### 🧪 Como executar testes

- Testes:
  ```
  rails test
  ```
- Testes de Sistema:
  ```
  rails test:system
  ```

### Principais libs e frameworks utilizados

- [Rails](https://rubyonrails.org/)
- [devise](https://github.com/heartcombo/devise)
- [devise-jwt](https://github.com/waiting-for-dev/devise-jwt)
- [SQLite](https://www.sqlite.org/index.html)
