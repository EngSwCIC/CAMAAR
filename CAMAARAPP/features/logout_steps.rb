
Given("I am loged in") do

    visit 'http://localhost:3000/'

    fill_in "user_email", with: "teste1@gmail.com"

    fill_in "user_password", with: "teste1"

    click_button "Login"

    sleep 3

    expect(current_url).to eq("http://localhost:3000/gerenciamento")
end


Given("I am on the gerenciamento page") do
    visit 'http://localhost:3000/gerenciamento'
end

When("I click the Logout button") do
    click_button "Logout"
    sleep 3
end

Then ("I should be redirected to the home page") do
    expect(current_url).to eq("http://localhost:3000/")
end