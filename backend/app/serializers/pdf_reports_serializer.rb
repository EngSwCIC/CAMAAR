class PdfReportsSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes
end
