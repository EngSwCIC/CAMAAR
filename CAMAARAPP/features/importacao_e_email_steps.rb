Given("I am on gerenciamento") do
    
    visit 'http://localhost:3000/'

    fill_in "user_email", with: "teste1@gmail.com"

    fill_in "user_password", with: "teste1"

    click_button "Login"

    sleep 3

    expect(current_url).to eq("http://localhost:3000/gerenciamento")
end

When ("I click the import button") do 
    click_button "Import"

    puts Aluno.all
    puts "teste"

    sleep 10
end

When ("I click the email button") do 
    click_button "Mail"
    sleep 10
end

Then ("The database should be updated") do
    
    expect(Aluno.count).to be > 0
end
