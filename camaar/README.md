# Sptint 2: Desenvolvimento

## Contribuindo

### Criação de Models

A criação das models se dá pelo seguinte comando Rails:

```bash
rails g model Nome atributo1:tipo atributo2:tipo ...
```

### Testes com Rspec

Seguindo [a documenteção do Rspec](https://github.com/rspec/rspec-rails?tab=readme-ov-file#creating-boilerplate-specs-with-rails-generate), para uma model já existente, rode o seguinte comando para criar testes:

```bash
rails generate rspec:model Nome
```

De maneira geral, os testes com Rspec possuem a seguinte estrutura:

```ruby
# /spec/models/nome_spec.rb
require 'rails-helper'

RSpec.describe Nome, type: :model do
    it 'descrição do teste' do
        # Lógica do teste
    end
end
```

Junto do Rspec, estamos utilizando a gem Factory Bot para simplificar a instanciação de models durante os testes.
Caso as models estejam sendo criadas pela primeira vez usando o comando mencionado acima, Factory Bot deve ser invocado e criará os arquivos necessários para utilizá-lo nos testes do Rspec.

Caso as models já existam, para usar Factory Bot nos testes de uma model em específico, é necessário criar o arquivo `spec/factories/<nome_da_model_NO_PLURAL>.rb` [e definir uma "Factory"](https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#factory-name-and-attributes), que é uma instância a ser reutilizada nos testes:

```ruby
FactoryBot.define do
    factory :noma_da_model do
        atributo1 { "Um exemplo de atributo" }
        atributo2 { "outro@exemplo.com" }
        ...
    end
end
```

Para rodar um teste, então, basta usar o comando `rspec`.
