json.extract! resposta_form, :id, :data_submissao, :formulario_id, :usuario_id, :created_at, :updated_at
json.url resposta_form_url(resposta_form, format: :json)
