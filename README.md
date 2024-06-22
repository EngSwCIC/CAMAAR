# CAMAAR

Sistema para avaliação de atividades acadêmicas remotas do CIC

# Ambiente

- Baixe a versão do [Ruby 3.3.3](https://www.ruby-lang.org/en/downloads/)

- Faça o clone do projeto

# Iniciando

- Entre na pasta src
- Primeiro, é necessário instalar todas as gemas do projeto

```
bundle install
```

- Em seguida, deve-se criar o banco e fazer as migrações

```
rails db:setup
```
ou

```
rake db:migrate
```

- Para popular a tabela, execute:

```
rails db:seed
```

- Para rodar o server: 
```
rails s
```

- Após iniciar o servidor, acesse a rota ```/sign_up``` e insira um endereço de email e uma senha

- Em seguida, acesse o link de cadastramento pelo terminal e defina uma nova senha para o mesmo email

- Caso deseje logar como admin, clique em "Esqueceu a senha?" e use o email "admin@email.com" para redefinição, após isso, basta repetir o passo anterior

# Testes

- Para executar o cucumber, basta rodar

```
bundle exec cucumber features/
```

- Para rodar os testes em Rspec, execute o comando:

```
rspec spec spec/
```