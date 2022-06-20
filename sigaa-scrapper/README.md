# sigaa-scrapper WIP

Crawler para pegar informações de turmas, matérias e alunos do sigaa.

## Dependencias
- Node 16.13.0
- Mariadb

## Como Executar o Crawler

### Variáveis de ambiente

- PORT
- USUARIO
  > Usuário do SIGAA (Com permissões de aluno enquanto for WIP)
- PASSWORD
  > Senha do SIGAA

### Instalação
  Primeiramente precisamos instalar todas as dependencias:
  
  ```
  npm install
  ```

  Após instalar as dependencias basta executar o index.js com o node:

  ```
  node index.js
  ```

### Principais libs utilizadas

- [Puppeteer](https://pptr.dev/)