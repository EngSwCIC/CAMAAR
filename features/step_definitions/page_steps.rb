Given(/^I am on the(?: main)? (.*) page$/) do |page_name|
  case page_name.downcase
  when 'management'
    visit manager_path
  when 'home'
    visit root_path
  when 'evaluations'
    visit evaluations_path
  else
    raise "Unknown page: #{page_name}"
  end
end
