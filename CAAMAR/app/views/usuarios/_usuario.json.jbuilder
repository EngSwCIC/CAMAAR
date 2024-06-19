json.extract! usuario, :id, :matricula, :nome, :email, :formacao, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)
