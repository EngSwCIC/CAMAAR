Given('there is one form answered for {string}') do |string|
  @study_class = FactoryBot.create(:study_class, name: string)
  @form = FactoryBot.create(:form_response, study_class: @study_class, response: "[]" )
end

Given('there is no form answered for {string}') do |string|
  @study_class = FactoryBot.create(:study_class, name: string)
  FormResponse.destroy_by(study_class: @study_class)
end