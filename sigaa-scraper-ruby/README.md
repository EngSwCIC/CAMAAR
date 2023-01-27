# Protótipo de Scrapper em Ruby

Antes de implementar as funções diretamente no rails, é interessante que o comportamento do scraper seja testado. Para isso, foi criado esse diretório provisório.

## Executando 

Primeiramente, instale as dependências corretas (lembrando que a versão do ruby utilizada é a 2.7.5)

```sh
bundle install
```

Em seguida,  altere as infomações contidas no arquivo ``config.sh``, para que seja possível efetuar login no SIGAA.

```sh
export SIGAA_USER='usuario'
export SIGAA_SENHA='senha#'

```

Em seguida execute o seguinte comando no terminal

```sh
source config.sh
```     

Por fim, execute o script

```
ruby scrapper.rb
```
