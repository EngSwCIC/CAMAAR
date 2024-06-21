Given(/^I am on the(?: main)? (\w+) page$/) do |page_name|
  case page_name.downcase
  when 'management'
    step 'I am an administrator'
    visit manager_path
  when 'home'
    visit root_path
  when 'evaluations'
    visit evaluations_path
  when 'send'
    step 'I am an administrator'
    visit to_send_templates_path
  else
    raise "Unknown page: #{page_name}"
  end
end

When(/^(?:I )?move to the(?: main)? (\w+) page$/) do |page_name|
  step "I am on the #{page_name} page"
end

Then(/^(?:I )?should be on the (\w+) page$/) do |page_name|
  case page_name.downcase
  when 'management'
    expect(page).to have_text('Gerenciamento')
    expect(page).to have_text('Semestre Atual')
  when 'home'
    raise "Unhandled page (how do I know i'm here?): #{page_name}"
  when 'evaluations'
    raise "Unhandled page (how do I know i'm here?): #{page_name}"
  when 'send'
    expect(page).to have_css('#template_id')
  else
    raise "Unknown 'should be' for page: #{page_name}"
  end
end
