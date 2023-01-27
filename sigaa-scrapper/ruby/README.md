# Protótipo de Scrapper em Ruby

Antes de implementar as funções diretamente no rails, é interessante que o comportamento do scraper seja testado. Para isso, foi criado esse diretório provisório.

## Executando 

Primeiramente altere as infomações contidas no arquivo ``config.sh``, para que seja possível efetuar login no SIGAA.

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
