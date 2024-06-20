Given('I am logged in as a student from class {string}') do |class_name|
  @user = User.new(
    :email => "teste@email.com",
    :matricula => "123456",
    :password => "senha123",
    :password_confirmation => "senha123"
  )

  @docente = User.create(
    :email => "docente@email.com",
    :matricula => "abc123",
    :password => "senha123",
    :password_confirmation => "senha123"
  )

  @study_class = StudyClass.create(
    :code => "cic01",
    :name => class_name,
    :classCode => "es123",
    :semester => "2024.1",
    :time => "Time",
  )
  @study_class.docente = @docente

  @user.study_classes << @study_class

  @user.save!

  login_as(@user, scope: :user)
end

Given('a form has been sent to this user') do
  @form_request = FormRequest.new
  @form_request.user = @user
  @form_request.study_class = @study_class
  @form_request.save!
end

Given('There are no forms registered') do
  FormRequest.destroy_all
end