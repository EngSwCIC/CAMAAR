# frozen_string_literal: true

json.extract! curso, :id, :nome, :created_at, :updated_at
json.url curso_url(curso, format: :json)
