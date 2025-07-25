# frozen_string_literal: true

json.extract! perguntum, :id, :template_id, :titulo, :tipo, :ordem, :created_at, :updated_at
json.url perguntum_url(perguntum, format: :json)
