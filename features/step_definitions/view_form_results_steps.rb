Given('I am logged in as the admin') do
  @user = FactoryBot.build(:user, admin: true)
  @user.email = "admin@email.com"
  @user.save!

  login_as(@user, scope: :user)
end

Given('a form has been answered') do
  @form_response = FactoryBot.build(:form_response)
  @form_response.study_class.name = "Turma 1"
  @form_response.save!
end

Given('no form has been answered') do
  FormResponse.destroy_all
end