Given('there are no users registed in our system') do
    User.destroy_all
end

Then('I should have a new user in the database') do
    expect(User.count).to be > 0
end

Given('all users were imported') do
    # all users from the valid jsons that i have
    FactoryBot.build(:user, nome: "Silva", matricula: "54321", usuario: "54321", email: "teste1@email.com").save
    FactoryBot.build(:user, nome: "FULANO DE CICLANO", matricula: "12345", usuario: "12345", email: "teste2@email.com").save
end