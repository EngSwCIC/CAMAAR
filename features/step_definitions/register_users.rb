Given('there are no users registed in our system') do
    expect(Participant.count).to be 0
end

Then('I should have a new user in the database') do
    expect(Participant.where(role: 'User').count).to eq(1)
end

Given('all users were imported') do
    expect(Participant.count).to be > 0
end