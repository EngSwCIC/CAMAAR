Given('I am logged in as a student from class {string}') do |class_code|
  @user = User.create(
    :email => "teste@email.com",
    :matricula => "123456",
    :password => "senha123",
    :password_confirmation => "senha123"
  )

  @study_class = StudyClass.create(
    :code => "cic01",
    :name => "ES",
    :classCode => class_code,
    :semester => "2024.1",
    :time => "Time"
  )

  @user.study_classes << @study_class

  login_as(@user, scope: :user)
end

Given('a form has been sent to this user') do
  @form_request = FormRequest.new({})
  @form_request.user = @user
  @form_request.study_class = @study_class
  @form_request.save!
end