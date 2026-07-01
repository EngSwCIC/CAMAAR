json.extract! resposta_elem, :id, :texto_resposta, :resposta_form_id, :elemento_form_id, :campo_form_id, :created_at, :updated_at
json.url resposta_elem_url(resposta_elem, format: :json)
