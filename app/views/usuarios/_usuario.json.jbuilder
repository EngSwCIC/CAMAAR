json.extract! usuario, :id, :matricula, :email, :nome, :formacao, :type, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)
