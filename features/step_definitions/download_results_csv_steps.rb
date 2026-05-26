Given("an answered form named {string} exists") do |name|
  @form_name = name
  @form_answered = true
end

Given("a form with no answers named {string} exists") do |name|
  @form_name = name
  @form_answered = false
end

And("I am on the results page of the form {string}") do |name|
  slug = name.downcase.tr(" .", "__").gsub(/[^a-z0-9_]/, "")
  visit("/resultados/#{slug}")
end

Then("the browser should start downloading the file {string}") do |filename|
  expect(page.response_headers["Content-Disposition"]).to include(filename)
end

And("the CSV file should contain the header with the form questions") do
  expect(page.body).to match(/pergunta/i)
end

And("the CSV file should contain one row per submitted answer") do
  expect(page.body.lines.count).to be > 1
end

And("no CSV file should be downloaded") do
  expect(page.response_headers["Content-Disposition"]).to be_nil
end
