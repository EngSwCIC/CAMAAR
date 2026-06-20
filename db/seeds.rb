# Garante a existência de um usuário administrador conhecido, para que qualquer
# pessoa que rode o projeto consiga acessar o sistema.
#
# Credenciais padrão de acesso:
#   Email: admin@unb.br
#   Senha: Admin123
#
# Rode com:  bin/rails db:seed
# (ou bin/rails db:setup / db:prepare, que já executam o seed automaticamente)
#
# O código é idempotente: pode ser executado quantas vezes quiser que o estado
# final é sempre o mesmo (cria se não existir, atualiza se já existir).

ADMIN_NOME  = "Admin".freeze
ADMIN_EMAIL = "admin@unb.br".freeze
ADMIN_SENHA = "Admin123".freeze
ADMIN_DEPARTAMENTO = "Administração Geral".freeze

departamento = Departamento.find_or_create_by!(nome_departamento: ADMIN_DEPARTAMENTO)

# Usa find_or_initialize para que, mesmo que o admin já exista, a senha conhecida
# seja (re)definida e o login fique garantido para qualquer um que rode o projeto.
admin_usuario = Usuario.find_or_initialize_by(email: ADMIN_EMAIL)
admin_usuario.nome                  = ADMIN_NOME
admin_usuario.role                  = :admin
admin_usuario.password              = ADMIN_SENHA
admin_usuario.password_confirmation = ADMIN_SENHA
admin_usuario.save!

# Vincula o perfil de Admin a um departamento (garante o departamento mesmo que
# o registro de Admin já exista sem um).
admin = Admin.find_or_initialize_by(usuario: admin_usuario)
admin.departamento = departamento
admin.save!

# Permite que o admin crie formulários/templates.
CriadorFormulario.find_or_create_by!(usuario: admin_usuario)

puts "Admin pronto -> email: #{ADMIN_EMAIL} | senha: #{ADMIN_SENHA}"
