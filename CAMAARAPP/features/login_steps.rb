Given("I am on the login page") do
    visit 'http://localhost:3000/users/sign_in'
    expect(@driver.title).to eq('Log in')
end

When("I enter my correct email and password") do
    fill_in "email", with: "teste1@gmail.com"
    fill_in "senha", with: "teste1"
end