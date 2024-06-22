# CAMAAR

Sistema para avaliação de atividades acadêmicas remotas do CIC

Baixe a versão do Ruby on Rails 3.3.3 - https://guides.rubyonrails.org/index.html

Faça o clone do projeto
``` https://github.com/Projeto-Final-ES-Grupo09/CAMAAR.git ```

# Iniciando

Entre na pasta src
Primeiro, é necessário instalar todas as gemas do projeto

```
bundle install
```

Em seguida, deve-se fazer as migrações

```
rails db:migrate
```
ou

```
rake db:migrate
```

Depois, popule o banco de dados com

```
rake db:seed
```

para rodar o server: 
```
rails s
```
se divirta!!!


# Testes

Para executar o cucumber, basta rodar

```
cucumber
```
