Given("I am on the login page") do
    visit 'http://localhost:3000/'
end

Then("I should see the login title") do 
    expect(page).to have_content("Login")
end


When("I enter my correct email") do
    fill_in "user_email", with: "dacam33c@gmail.com"
end

When("I enter my correct password") do
    fill_in "user_password", with: "teste2"
end

When("I click the Login button") do
    click_button "Login"
    sleep 3
    visit 'http://localhost:3000/'
    sleep 2
end

Then ("I should be redirected to home page") do
    expect(current_url).to eq("http://localhost:3000/user_home")
end

And ("I should see a welcome message") do 
    expect(page).to have_content("Bem vindo")

    click_button "Logout"
end             