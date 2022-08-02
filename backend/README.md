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

Execute o seguinte comando para aplicar as migrations ao banco de dados:

```
rake db:migrate
```

E para preencher o banco com dados iniciais extraídos do SIGAA, execute:

```
rails db:seed
```

Após isso basta iniciar a aplicação

```
rails server
```
O back-end ficará acessível na porta 3030. 

### Rotas do back-end

Estão disponíveis as seguintes rotas:
- POST /auth/login
  > Retorna um token valido
- POST /auth/logout
- POST /auth/register

### Autenticação

A autenticação da API é feita com JWT( utilizando o devise como helper ).
Para acessar endpoints protegidos basta passar um token valido no header `Authorization`.
A estrutura do header com token seria a seguinte:
```
Authorization: Bearer <Token-Valido>
```

As rotas do back-end podem receber requisições https através do navegador ou 
de clientes http como:
- [Postman](https://insomnia.rest/)
- [Insomina](https://insomnia.rest/download)
  
### 🧪 Como executar testes com RSpec

  ```
  rspec ./spec/models/exemple_spec.rb
  ```

### Principais libs e frameworks utilizados

- [Rails](https://rubyonrails.org/)
- [devise](https://github.com/heartcombo/devise)
- [devise-jwt](https://github.com/waiting-for-dev/devise-jwt)
- [SQLite](https://www.sqlite.org/index.html)
- [RSpec](https://rspec.info/)
