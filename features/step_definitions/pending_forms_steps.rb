Then('I should see form {string}') do |class|
    expect(page).to have_content(class)
end

Then('I should see no form {string}') do |class|
    expect(page).not_to have_content({class})
end
