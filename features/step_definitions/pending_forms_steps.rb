Then('I should see form {string}') do |form|
    expect(page).to have_content(form)
end

Then('I should see "Nenhum formulario disponível para a turma {string}"') do |class|
    expect(page).to have_content("Nenhum formulario disponível para a turma #{class}")
end