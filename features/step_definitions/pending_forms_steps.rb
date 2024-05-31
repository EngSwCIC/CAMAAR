Then('I should see form {string}') do |turma|
    expect(page).to have_content(turma)
end

Then('I should see no form {string}') do |turma|
    expect(page).not_to have_content(turma)
end
