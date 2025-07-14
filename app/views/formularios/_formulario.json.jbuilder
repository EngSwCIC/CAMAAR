# frozen_string_literal: true

json.extract! formulario, :id, :template_id, :turma_id, :coordenador_id, :data_envio, :data_fim, :created_at,
              :updated_at
json.url formulario_url(formulario, format: :json)
