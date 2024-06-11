json.extract! question, :id, :text, :type, :template_id, :created_at, :updated_at
json.url question_url(question, format: :json)
