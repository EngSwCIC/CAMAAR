# CAMAAR

Projeto desenvolvido em Ruby on Rails para a disciplina de Engenharia de Software.

## Tecnologias utilizadas

- Ruby 3.2.10
- Ruby on Rails 8.1.3
- SQLite3
- Puma
- Capybara
- Selenium WebDriver

## Pré-requisitos

Antes de rodar o projeto, verifique se você possui instalado:

- Ruby
- Rails
- Bundler
- SQLite3
- Git

Para verificar as versões instaladas, execute:

```bash
ruby --version
rails --version
bundle --version
sqlite3 --version
git --version
```

## Clonando o projeto

Clone o repositório:

```bash
git clone https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git
```

Entre na pasta do projeto:

```bash
cd SEU-REPOSITORIO
```

Substitua `SEU-USUARIO` e `SEU-REPOSITORIO` pelos dados corretos do repositório.

## Instalando as dependências

Na raiz do projeto, execute:

```bash
bundle install
```

Esse comando instala todas as gems necessárias declaradas no arquivo `Gemfile`.

## Preparando o banco de dados

Como o projeto utiliza SQLite, execute:

```bash
bin/rails db:prepare
```

No Windows, caso o comando acima não funcione, use:

```bash
ruby bin\rails db:prepare
```

Esse comando cria o banco de dados, executa as migrations e, em um banco novo, também executa o `db/seeds.rb` — que cria o usuário administrador padrão (veja a seção [Acesso ao sistema](#acesso-ao-sistema)).

Se o seu banco **já existe** e você só quer garantir o usuário admin, rode o seed manualmente (é idempotente):

```bash
bin/rails db:seed
```

## Rodando o servidor

Para iniciar o servidor Rails, execute:

```bash
bin/rails server
```

No Windows, recomenda-se usar:

```bash
ruby bin\rails server
```

ou:

```bash
bundle exec rails server
```

Depois acesse no navegador:

```text
http://localhost:3000
```

Se a página inicial do Rails aparecer, o projeto está rodando corretamente.

## Acesso ao sistema

O `db/seeds.rb` cria (de forma idempotente) um usuário administrador padrão, para que qualquer pessoa que rode o projeto consiga acessar o sistema:

```text
Email: admin@unb.br
Senha: Admin123
```

Esse usuário é criado automaticamente em um banco novo (`bin/rails db:prepare`) ou ao rodar `bin/rails db:seed`. Ele já vem com um departamento ("Administração Geral") e perfil de criador de formulários.

## Observação para usuários Windows

Caso o servidor inicie e depois caia com um erro parecido com:

```text
No such file or directory - bin/rails
```

abra o arquivo:

```text
config/puma.rb
```

e comente a linha:

```ruby
plugin :tmp_restart
```

deixando assim:

```ruby
# plugin :tmp_restart
```

Depois tente iniciar o servidor novamente:

```bash
ruby bin\rails server
```

## Avisos relacionados ao VIPS

Em alguns ambientes Windows, podem aparecer avisos semelhantes a:

```text
VIPS-WARNING unable to load ...
```

Esses avisos estão relacionados ao processamento de imagens e, em geral, não impedem a aplicação Rails de iniciar. Caso o projeto ainda não utilize upload ou manipulação de imagens, eles podem ser ignorados inicialmente.

## Testes

Para rodar os testes padrão do Rails:

```bash
bin/rails test
```

No Windows:

```bash
ruby bin\rails test
```

O projeto também possui suporte a testes com Capybara e Selenium WebDriver.

## Estrutura básica do projeto

```text
app/        # Código principal da aplicação
config/     # Configurações do Rails
db/         # Banco de dados e migrations
test/       # Testes automatizados
public/     # Arquivos públicos
Gemfile     # Dependências do projeto
```

## Comandos úteis

Instalar dependências:

```bash
bundle install
```

Preparar banco de dados:

```bash
ruby bin\rails db:prepare
```

Rodar servidor:

```bash
ruby bin\rails server
```

Rodar testes:

```bash
ruby bin\rails test
```

Ver rotas disponíveis:

```bash
ruby bin\rails routes
```

Abrir console Rails:

```bash
ruby bin\rails console
```

## Status do projeto

Projeto em desenvolvimento.
