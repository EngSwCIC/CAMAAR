Then(/^my responses should be saved in the database$/) do
  response = Response.last
  expect(response.question_1).to eq('Great class')
  expect(response.question_2).to eq('Very helpful instructor')
end

Then(/^my responses should not be saved in the database$/) do
  expect(Response.count).to eq(0)
end