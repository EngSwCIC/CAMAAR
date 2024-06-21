# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

## Dependências
 
- Ruby 2.7.8
- Rails 7.1.3.4
- Gem 3.3.3
  - Para atualizar a versão do gem, apenas execute o comando:
  - `gem update -system 3.3.3`
- Cucumber 8.0.0
- Tailwind CSS Rails 2.6
  - Um problema comum que acontece é o desaparecimento do arquivo `./app/assets/builds/tailwind.css` ao copiar o repositório a um ambiente local
  - No caso dele ocorrer, execute `./bin/dev` que o arquivo deve ser gerado automaticamente
- SQLite3 1.4 (versão da gema)

## Como executar o servidor

Para rodar o servidor, há duas formas possíveis:
- Executar o comando `rails s` na linha de comando
- Executar o arquivo `./bin/dev`

## Como executar os testes

Primeiramente, é necessário realizar as migrações existentes para o ambiente de teste com o comando

```shell
rails db:migrate RAILS_ENV=test
```

Depois disso, para executar os testes de integração desenvolvidos com o cucumber, execute o comando:
```shell
cucumber
```

Por fim, para executar todos os testes desenvolvidos com o RSpec, execute o comando:
```shell
rspec
```
Para que os testes que passaram sejam exibidos no prompt de comando também, execute:
```shell
rspec -fd spec/
```
