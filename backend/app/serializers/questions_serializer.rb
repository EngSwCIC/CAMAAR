class QuestionsSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes :survey_id, :code, :id
end
