class AnswersSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes :member_id, :option_id, :code, :id
end
