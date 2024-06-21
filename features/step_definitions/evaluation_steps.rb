When(/^I should see at least one (\w+) card$/) do |text|
  case text.downcase
  when 'result'
    expect(page).to have_text 'Baixar Resultados'
  when 'evaluation'
    expect(page).to have_text 'Avaliar Disciplina'
  else
    raise "Unsupported argument: #{text}"
  end
end

When(/^I should not see any (\w+) cards$/) do |text|
  case text.downcase
  when 'result'
    expect(page).not_to have_text 'Baixar Resultados'
  when 'evaluation'
    expect(page).not_to have_text 'Avaliar Disciplina'
  else
    raise "Unsupported argument: #{text}"
  end
end

Given('the evaluations page is empty') do
  step 'move to the evaluations page'
  expect(page).not_to have_text 'Professor:'
  expect(page).not_to have_text 'Semestre:'
end
