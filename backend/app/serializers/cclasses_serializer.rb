class CclassesSerializer
    include FastJsonapi::ObjectSerializer
    set_key_transform :dash

    attributes :id, :code, :semester, :time
  end
