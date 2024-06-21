## Dependências
O projeto foi desenvolvido sumariamente em ambiente linux, tendo sido testados os seguintes sistemas operacionais com êxito:

- 6.8.9-arch1-2
- 6.6.9-1kali1

Além disso, para a execução dos testes com rspec, é necessário que o navegador Firefox esteja devidamente instalado, dado ao fato de que o webdriver utilizado - selenium - utiliza o browser firefox em nosso ambiente de testes.

As versões do ruby testadas com êxito foram ruby 3.3.0 e ruby 3.3.1. Você mode alterar sua versão a partir das seguintes bibliotecas:
- [RVM](https://rvm.io/)
- [rbenv](https://github.com/rbenv/rbenv)

## Setup ##
Abra o terminal e clone o repositório do projeto:
```
git clone https://github.com/marqueswill/CAMAAR/tree/sprint-2 
```

Navegue até o repositório do projeto, e acesse a subpasta "camaar"
```
cd camaar
```

Instale as gems e dependências necessárias com o bundler (é necessário ruby >= 3.3.0):
```
bundle install
```

Execute os seguintes comandos para fazer as migrations e setup da database:
```
rails db:drop:all
rails db:
```

E em seguida inicie o servidor local com o rails
```
rails server
```
E acesse o site a partir do ```localhost:3000```

## Testing ##

### Rspec

```
bundle exec rspec spec/ 
```

### Cucumber
```
bundle exec cucumber features/ 
```

O ambiente de testes foi configurado utilizando a gem 'simplecov', de maneira a integrar o Rspec com o Cucumber. Você pode visualizar a cobertura dos testes abrindo o arquivo ``` camaar/coverage/index.html ``` no seu navegador

## Guia de uso

### Admin/Coordenador
Ao acessar o sistema como administrador, utilize os dados gerados pela seed e faça login como coordenador de algum departamento conhecido 

email (mesmo padrão para todos departamentos da seed) 
```
admin.cic@gmail.com
```

senha (mesma senha para todos) 
```
admin123
``` 

Embora a seed já tenha registrado algumas turmas, alunos e professores, para que o email de cadastro seja enviado você precisará importar os dados do json novamente. Se for necessário, podem ser adicionados departamentos e turmas por departamento, bastando importar o respectivo aquivo json, e respeitando as regras de integridade pré-existentes no arquivo `/camaar/db/departments.json`.

O repositório possui alguns arquivos utilizados na seed e nos testes presentes na pasta `/camaar/db/`. Importar o arquivo `class_members.json` irá enviar um email solicitando que os usuários se registrem. 

Sendo um coodenador/administrador, você pode criar templates com questões textuais e de múltipla escolha. 

Para o envio de um formulário, acesse a página de envio selecione a opção de formulário para aluno e/ou professor e selecione as turmas desejadas.

Formulários enviados podem ser visualizados na página "Resultados". Quando algum aluno/professor submeter uma resposta, o coordenador será capaz de exportar as respostas em csv e o número de respostas em um gráfico (somente número de respostas). Para visualizar todas respostas do form, você pode navegar para a página de "resumo" clickando no nome presente no card. 

### Aluno/Professor

Se você for simular um usuário registrado no json, acesse o servidor de emails `localhost:3000/mails` (fictício) e procure seu endereço de do usuário. Nele, ao clickar no link de "Registrar", você será submetido a uma página de cadastro onde você pode informar uma senha para sua conta. Após a submissão do registro, você precisará confirmar o cadastro a partir de outro email enviado.

Você pode responder formulários enviados acessando a página "Pendentes" e pode visualizar suas respostas a partir da página "Respondidos" 
