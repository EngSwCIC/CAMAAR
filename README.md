### CAMAAR

O projeto **CAMAAR** (Criação e Automação de Modelos de Avaliação e Relatórios) é uma aplicação web desenvolvida para automatizar formulários de avaliação na Universidade de Brasília. O objetivo principal do CAMAAR é facilitar o trabalho dos coordenadores, permitindo a criação de relatórios baseados em questionários e auxiliando na análise dos dados coletados. Além disso, os coordenadores poderão criar questionários personalizados a partir de templates, otimizando o processo de avaliação e garantindo maior eficiência e precisão nas análises.

---

### Status

🚧 **CAMAAR em construção...** 🚧

---

### Pré-requisitos

Antes de começar, você vai precisar ter instalado em sua máquina as seguintes ferramentas:

- **Git**: [Git](https://git-scm.com)
- **Ruby on Rails**: [Ruby on Rails](https://rubyonrails.org)

O passo a passo da instalação em ambiente Linux e Windows está na documentação delas.

### Instruções de instalação

1. Clone este repositório:

    ```bash
    git clone https://github.com/LuisBFlexa/CAMAAR_grupo_3.git
    ```

2. Acesse a pasta do projeto no terminal/cmd:

    ```bash
    cd CAMAAR_grupo_3
    ```

3. Instale as dependências:

    ```bash
    bundle install
    ```

4. Rode as migrations e o banco de dados:

    ```bash
   rails db:create
   rails db:migrate
   rails db:seed
    ```

3. Instale as dependências:

    ```bash
    bundle install
    ```

4. Execute a aplicação em modo de desenvolvimento:

    ```bash
    rails server
    ```

5. O servidor inciará na porta:3000 - acesse [http://localhost:3000](http://localhost:3000)

---

### Tecnologias

As seguintes ferramentas foram usadas na construção do projeto:

#### **Aplicação em geral**

- **[Ruby on Rails](https://rubyonrails.org)**: Framework principal para desenvolvimento web. Utilizado para construção do backend, gerenciamento de banco de dados e renderização de views.

#### **Backend**

- **Ruby on Rails**: Framework principal para desenvolvimento web.
- **Devise**: Gem para autenticação de usuários.
- **FactoryBot**: Biblioteca para configurar e criar objetos de teste.
- **RSpec**: Framework de testes para Ruby e Rails.
- **Cucumber**: Ferramenta para testes de aceitação baseados em comportamento.

#### **Frontend**

- **HTML/CSS/JavaScript**: Tecnologias padrão para desenvolvimento frontend.
- **Webpacker**: Gem que integra Webpack ao Rails para empacotamento de ativos JavaScript.
- **Bootstrap**: Framework CSS para design responsivo e componentes pré-estilizados.

#### **Banco de Dados**

- **SQLite3**: Sistema de gerenciamento de banco de dados. O exemplo utiliza SQLite para desenvolvimento, mas pode ser configurado para PostgreSQL ou MySQL.

---

### Licença

Licença **MIT**

```
Copyright (c) 2024 CAMAAR GRUPO-3

A permissão é concedida, gratuitamente, a qualquer pessoa que obtenha uma cópia
deste software e dos arquivos de documentação associados (o "CAMAAR GRUPO-3"), para lidar
no Software sem restrição, incluindo, sem limitação, os direitos
de usar, copiar, modificar, mesclar, publicar, distribuir, sublicenciar e/ou vender
cópias do Software, e permitir às pessoas a quem o Software é
fornecido para fazer isso, sujeito às seguintes condições:

O aviso de copyright acima e esta permissão devem ser incluídos em todas
as cópias ou partes substanciais do Software.

O SOFTWARE É FORNECIDO "COMO ESTÁ", SEM GARANTIA DE QUALQUER TIPO, EXPRESSA OU
IMPLÍCITA, INCLUINDO, MAS NÃO SE LIMITANDO ÀS GARANTIAS DE COMERCIALIZAÇÃO,
ADEQUAÇÃO A UM DETERMINADO FIM E NÃO VIOLAÇÃO. EM NENHUM CASO OS
AUTORES OU DETENTORES DOS DIREITOS AUTORAIS SERÃO RESPONSÁVEIS POR QUALQUER REIVINDICAÇÃO, DANOS OU OUTRAS
RESPONSABILIDADES, SEJA EM UMA AÇÃO DE CONTRATO, ATO ILÍCITO OU DE OUTRA FORMA, DECORRENTE DE,
FORA DE OU EM CONEXÃO COM O SOFTWARE OU O USO OU OUTRAS NEGOCIAÇÕES NO
SOFTWARE.
```

---

### Autor

Desenvolvido por:
LUIS ANTONIO BENJAMIM FLEXA
THIAGO FERNANDES CARVALHO DE SOUZA 
GABRIEL ROBERTO DE QUEIROZ
CARLOS EDUARDO DE SOUSA ARNAUD
GUSTAVO VIEIRA DE ARAUJO 
