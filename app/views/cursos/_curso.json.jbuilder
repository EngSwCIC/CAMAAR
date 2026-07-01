json.extract! curso, :id, :codigo, :nome, :departamento_id, :created_at, :updated_at
json.url curso_url(curso, format: :json)
