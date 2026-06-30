# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

## Sobre o CAMAAR:
Essa aplicação é um projeto desenvolvido com Rails, visando a melhor compreensão do modelo arquitetural MVC sob as perspectivas de um framework atualizado e flexível. Nela, a proposta é poder servir como um _hub_ de integração entre docentes e discentes por meio de avaliações e atividades remotas, possibilitando a expansão do ambiente acadêmico para o mundo digital. Assim, funciona para prover uma plataforma de realização das atividades, bem como de gerenciamento e de monitoramento dessas atividades, por parte dos discentes.

## Detalhes técnicos:

* Versão do Ruby / Rails: 3.3.11 (Ruby), 8.1.3 (Rails)

* Dependências: Todas as dependências do projeto podem ser encontradas no [_Gemfile_](Gemfile) da aplicação, mas destaca-se o uso das gemas **Puma** para a hospedagem web, **Rspec, Cucumber e Capybara** para testes, **CSV** para tratamento de dados externos, **Selenium** como um Web-driver para o processamento do JavaScript, e o **Devise** para tratar de funções de autenticação dos usuários de modo simplificado. Além disso, ressalta-se a dependência do **SQLite** como banco de dados da aplicação.

* Inicialização do banco de dados: O próprio Rails já fornece uma estratégia de _marshalling_ dos modelos para uma base de dados em SQLite, sendo apenas necessária a execução de comandos para configuração, migração e população desse banco de dados com as informações de teste, por meio dos comandos:

```
rails db:create
rails db:migrate
rails db:seed
```

* Setup da aplicação: A fim de rodar a aplicação, é bom garantir que todas as dependências contidas no [_Gemfile_](Gemfile) estão presentes na máquina, por meio do comando:
```
bundle exec install
```
Além disso, só é preciso rodar a aplicação em si, por meio do comando do Rails:
```
rails server
```
