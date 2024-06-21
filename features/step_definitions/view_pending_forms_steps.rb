Given('I am logged in as a student from class {string}') do |class_name|
  @user = FactoryBot.build(:user)
  @user.email = "teste@email.com"

  @docente = FactoryBot.build(:user)
  @docente.email = "docente@email.com"
  @docente.save!

  @study_class = FactoryBot.build(:study_class)
  @study_class.name = class_name
  @study_class.docente = @docente
  @study_class.save!

  @user.study_classes << @study_class
  @user.save!

  login_as(@user, scope: :user)
end

Given('a form has been sent to this user') do
  @template = FactoryBot.build(:template)

  @form_request = FormRequest.new
  @form_request.user = @user
  @form_request.study_class = @study_class
  @form_request.template = @template
  @form_request.save!
end

Given('There are no forms registered') do
  FormRequest.destroy_all
end