# Sptint 2: Desenvolvimento

## Criação de Models

A criação das models se dá pelo seguinte comando Rails:

```bash
rails g model nome atributo1:tipo atributo2:tipo ...
```

## Testes com Rspec

Seguindo [a documenteção do Rspec](https://github.com/rspec/rspec-rails?tab=readme-ov-file#creating-boilerplate-specs-with-rails-generate), para uma model já existente, rode o seguinte comando para criar testes:

```bash
rails generate rspec:model nome
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

Para rodar um teste, então, basta usar o comando `rspec`.
