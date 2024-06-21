Given('I am logged in as a student') do
  @user = FactoryBot.build(:user)
  @user.email = "teste@email.com"

  login_as(@user, scope: :user)
end

Given("There is a form request") do
  @form_request = FactoryBot.build(:form_request)
  @form_request.user = @user

  @form_request.template.template_questions << TemplateQuestion.new(
    title: "O que você achou da turma?",
    question_type: "text",
    content: ""
  )
  @form_request.template.template_questions << TemplateQuestion.new(
    title: "O que você achou do professor?",
    question_type: "text",
    content: ""
  )

  @form_request.save!
end

Given("I visit the RespondForm page") do
  visit "/avaliacoes/#{@form_request.id}"
end

Then(/^my responses should be saved in the database$/) do
  response = FormResponse.last
  expect(response.response).to eq(["Ótima turma", "Ótimo professor"].to_json)
end

Then(/^my responses should not be saved in the database$/) do
  expect(FormResponse.count).to eq(0)
end

Then("I should stay at the RespondForm page") do
  assert_equal URI.parse(current_url).path, "/avaliacoes/#{@form_request.id}"
end