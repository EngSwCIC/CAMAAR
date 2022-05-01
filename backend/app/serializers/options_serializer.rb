class OptionsSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes :id, :code, :question_id, :description, :in_blank
end
