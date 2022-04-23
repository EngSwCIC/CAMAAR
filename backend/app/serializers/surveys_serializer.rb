class SurveysSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes :id, :code, :cclass_id
end
