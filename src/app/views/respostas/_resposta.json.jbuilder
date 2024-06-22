json.extract! resposta, :id, :id_questao, :id_formulario, :usuario, :resposta, :numero, :created_at, :updated_at
json.url resposta_url(resposta, format: :json)
