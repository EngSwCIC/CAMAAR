# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

# 1. Como fazer o login como Administrador?

Você pode utilizar o e-mail ou a matrícula do administrador:

- **E-mail:** `admin@unb.br`
- **Matrícula:** `admin_matricula`
- **Senha:** `admin`

> Nota: em cenários de testes automatizados, a senha pode ser `admin123`.


---

# 2. Como fazer o login como Docente (Professor)?

O docente padrão carregado a partir do arquivo `class_members.json` possui os seguintes dados de acesso:

- **E-mail:** `mholanda@unb.br`
- **Matrícula:** `83807519491`
- **Senha:** `senha123`


---

# 3. Como fazer o login como Discente (Aluno)?

Os discentes importados do arquivo `class_members.json` utilizam a própria matrícula como senha padrão.

Segue um exemplo de conta de aluno disponível:

## Exemplo 1 (Ana Clara Jordao Perna)

- **E-mail:** `acjpjvjp@gmail.com`
- **Matrícula:** `190084006`
- **Senha:** `190084006`

---

# 4. Como rodar o projeto?

Certifique-se de ter o Ruby (versão compatível com o `.ruby-version` ou Gemfile) e o Node.js instalados.

1. **Instale as dependências:**
   ```bash
   bundle install
   yarn install # Se houver dependências de frontend via yarn
   ```

2. **Configure o banco de dados:**
   ```bash
   bin/rails db:create db:migrate db:seed
   ```
   *Nota: O comando `db:seed` irá popular o banco de dados com usuários e templates padrões, além de dados provenientes do arquivo `class_members.json`.*

3. **Inicie o servidor local:**
   ```bash
   bin/rails server
   ```

4. **Acesse a aplicação:**
   Abra o navegador em `http://localhost:3000`.

---

# 5. Como executar os testes?

O projeto utiliza **RSpec** para testes de unidade/integração, **Cucumber** para testes de comportamento (BDD) e **RuboCop** para padronização de código. Recomendamos sempre utilizar os binários da pasta `bin/` para garantir que o ambiente correto (Spring/Binstubs) seja carregado.

1. **Executar a suíte de testes do RSpec:**
   ```bash
   bin/rspec
   ```

2. **Executar a suíte de testes do Cucumber:**
   ```bash
   bin/cucumber
   ```

3. **Verificar a formatação do código (RuboCop):**
   ```bash
   bin/rubocop
   ```
   *Para tentar corrigir automaticamente as infrações, utilize `bin/rubocop -a` (safe auto-correct) ou `bin/rubocop -A` (all auto-correct).*

# 6. Como testar a redefinição de senha?

1. Acesse a página de login (`/login`).
2. Clique no link **"Esqueci minha senha"**.
3. Informe o e‑mail cadastrado do usuário (ex.: admin@unb.br) e envie.
4. O sistema enviará um e‑mail (simulado em `log/development.log`) contendo um token de redefinição.
5. Copie o link do e‑mail e abra no navegador.
6. Defina a nova senha e confirme.
7. Faça login com a nova senha para validar que a troca foi bem‑sucedida.

> **Dica:** Em ambiente de desenvolvimento, o e‑mail é impresso no log `log/development.log`. Use `tail -f log/development.log` para visualizá‑lo.
