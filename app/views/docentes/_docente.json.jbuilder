json.extract! docente, :id, :matricula, :email, :nome, :formacao, :created_at, :updated_at
json.url docente_url(docente, format: :json)
